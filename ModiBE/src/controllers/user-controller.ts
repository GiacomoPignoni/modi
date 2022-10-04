import admin, { firestore } from "firebase-admin";
import { FirebaseCollections } from "../models/firebase/collections";
import { FirebaseUser, FirebaseUserProps } from "../models/firebase/user";
import { AcceptPartnerRequestReq, AskToBePartnerReq as SendPartnerRequestReq, CheckNicknameReq, RegisterMessagingTokenReq, RegisterUserReq, RejectPartnerRequestReq, RemoveMessagingTokenReq, UpdateNicknameReq } from "../models/req/user-reqs";
import { PartnerRequestDetails, User } from "../models/res/user-reses";
import { AuthUser } from "../models/auth-user";
import { UserMapper } from "../mappers/user-mapper";
import { errorCodes } from "../utils/error-codes";
import { NotificationsController } from "./notifications-controller";
import { RemoteMessageData, RemoteMessagePartnerReminder, RemoteMessagePartnerAccepted, RemoteMessagePartnerRequest, RemoteMessageType } from "../models/remote-message";

/**
 * Controller to execute user related actions
 */
export class UserController {
  /**
   * Register a new user on the Firebase database
   * @param {RegisterUserReq} req The request with the information to register a new user
   * @param {AuthUser} authUser The user on which to perform the action
   */
  public static async registerNew(req: RegisterUserReq, authUser: AuthUser): Promise<void> {
    this.checkRegisterUserReq(req);

    const collection = admin.firestore().collection(FirebaseCollections.users);
    const doc = await collection.doc(authUser.id).get();

    if (doc.exists) {
      throw new Error(errorCodes.user.alreadyRegisteredUser);
    } else {
      // Check if nickname is already used
      const query = await collection.where(FirebaseUserProps.nicknameLowerCase, "==", req.nickname.toLowerCase()).get();
      if (query.size > 0) {
        throw new Error(errorCodes.user.nicknameAlreadyExists);
      }

      const userModel: FirebaseUser = UserMapper.getModelToCreateUser(req.nickname);
      await collection.doc(authUser.id).set(userModel);
    }
  }

  /**
   * Check if a nickname is used
   * @param {CheckNicknameReq} req The request with the information to check a nickname
   * @return {Promise<boolean>}
   */
  public static async checkNickname(req: CheckNicknameReq): Promise<boolean> {
    const query = await admin.firestore().collection(FirebaseCollections.users)
        .where(FirebaseUserProps.nicknameLowerCase, "==", req.nickname.toLowerCase()).get();
    return query.size <= 0;
  }

  /**
   * Update the nickname of the given user
   * @param {UpdateNicknameReq} req The request with the information with the new nickname
   * @param {AuthUser} authUser The user on which to perform the action
   */
  public static async updateNickname(req: UpdateNicknameReq, authUser: AuthUser): Promise<void> {
    this.checkUpdateNicknameReq(req);

    const userDoc = await this.getUserDoc(authUser.id);

    // Check if nickname is already used
    const query = await admin.firestore().collection(FirebaseCollections.users)
        .where(FirebaseUserProps.nicknameLowerCase, "==", req.nickname.toLowerCase()).get();
    if (query.size > 0) {
      throw new Error(errorCodes.user.nicknameAlreadyExists);
    }

    await userDoc.ref.update(UserMapper.getModelForUpdateNickname(req.nickname));
  }

  /**
   * Return the given user profile
   * @param {AuthUser} authUser The user of to find the profile
   * @return {Promise<User>}
   */
  public static async get(authUser: AuthUser): Promise<User> {
    const userDoc = await this.getUserDoc(authUser.id);

    const userData: FirebaseUser = userDoc.data()! as FirebaseUser;
    let parterNickname: string | undefined = undefined;

    // Find the partner nickname
    if (userData.p !== undefined) {
      const partnerDoc = await admin.firestore().collection(FirebaseCollections.users).doc(userData.p!).get();
      if (partnerDoc.exists) {
        parterNickname = (partnerDoc.data()! as FirebaseUser).n;
      }
    }

    const res = UserMapper.fromFirebaseModelToUser(userDoc.data() as FirebaseUser, authUser.email!, parterNickname);
    return res;
  }

  /**
   * Return the given user partner requests
   * @param {AuthUser} authUser The user on which to perform the action
   * @return {Promise<PartnerRequestDetails[]>}
   */
  public static async getPartnerRequests(authUser: AuthUser): Promise<PartnerRequestDetails[]> {
    const userDoc = await this.getUserDoc(authUser.id);
    const userData: FirebaseUser = userDoc.data()! as FirebaseUser;

    if (userData.pr !== undefined) {
      const requests: PartnerRequestDetails[] = [];

      for (const requestUserId of userData.pr) {
        const requestUserDoc = await admin.firestore().collection(FirebaseCollections.users).doc(requestUserId).get();

        if (requestUserDoc.exists) {
          const requestUserData: FirebaseUser = requestUserDoc.data()! as FirebaseUser;

          if (requestUserData.p === undefined) {
            requests.push({
              id: requestUserDoc.id,
              nickname: requestUserData.n,
            });
          }
        }
      }

      return requests;
    } else {
      return [];
    }
  }

  /**
   * Send a partner request to the given user
   * @param {SendPartnerRequestReq} req The request with the nickname of the user to send the request to
   * @param {AuthUser} authUser The user that send the request
   */
  public static async sendPartnerRequest(req: SendPartnerRequestReq, authUser: AuthUser): Promise<void> {
    const userDoc = await this.getUserDoc(authUser.id);
    const userData: FirebaseUser = userDoc.data()! as FirebaseUser;

    // Check if user is trying to ask to him self
    if (userData.n === req.partnerNickname.toLowerCase()) {
      throw new Error(errorCodes.user.userNotFound);
    }

    // Check user already has a partner
    if (userData.p) {
      throw new Error(errorCodes.user.alreadyHasPartner);
    }

    // Find the user with the given nickname
    const partnerQuery = await admin.firestore().collection(FirebaseCollections.users)
        .where(FirebaseUserProps.nicknameLowerCase, "==", req.partnerNickname.toLocaleLowerCase()).get();

    if (partnerQuery.size > 0) {
      const partnerDoc = partnerQuery.docs[0];
      const partnerData: FirebaseUser = partnerDoc.data() as FirebaseUser;

      // Check is the given user already has a partner
      if (partnerData.p !== undefined) {
        throw new Error(errorCodes.user.partnerAlreadyHasPartner);
      }

      // Check if the given user already has a request from the user
      const userIdexInPR = partnerData.pr?.findIndex((x) => x === authUser.id);
      if (userIdexInPR === -1 || userIdexInPR === undefined) {
        const partnerRequests = partnerData.pr ?? [];

        partnerRequests.push(authUser.id);
        partnerDoc.ref.update(UserMapper.getModelToUpdatePartnerRequests(partnerRequests));

        NotificationsController.send(
            "You have a partner request",
            `${userData.n} wants to become your partner`,
            new RemoteMessagePartnerRequest(userData.n),
            partnerDoc,
            authUser,
        );
      } else {
        throw new Error(errorCodes.user.requestAlreadySent);
      }
    } else {
      throw new Error(errorCodes.user.partnerNicknameNotFound);
    }
  }

  /**
   * Accept a user partner request of the given user
   * @param {AcceptPartnerRequestReq} req The request with the user id to be accepted as a partner
   * @param {AuthUser} authUser The user on which to perform the action
   */
  public static async acceptPartnerRequest(req: AcceptPartnerRequestReq, authUser: AuthUser): Promise<void> {
    const userDoc = await this.getUserDoc(authUser.id);
    const userData: FirebaseUser = userDoc.data()! as FirebaseUser;

    // Check is user already has a partner
    if (userData.p !== undefined) {
      throw new Error(errorCodes.user.alreadyHasPartner);
    }

    const partnerDoc= await admin.firestore().collection(FirebaseCollections.users).doc(req.partnerId).get();

    if (partnerDoc.exists) {
      if (userData.pr?.findIndex((x) => x === partnerDoc.id) === -1) {
        throw new Error(errorCodes.user.userNotSentYouRequest);
      }

      const partnerData: FirebaseUser = partnerDoc.data() as FirebaseUser;

      // Check if the other user already has a partner
      if (partnerData.p !== undefined) {
        throw new Error(errorCodes.user.partnerAlreadyHasPartner);
      }

      // Update all the two docs with the partners id
      userDoc.ref.update(UserMapper.getModelToAddPartner(partnerDoc.id));
      partnerDoc.ref.update(UserMapper.getModelToAddPartner(userDoc.id));

      NotificationsController.send(
          "Partner request accepted!",
          `Now ${userData.n} is your partner`,
          new RemoteMessagePartnerAccepted(userData.n),
          partnerDoc,
          authUser,
      );
    } else {
      throw new Error(errorCodes.user.partnerNotFound);
    }
  }

  /**
   * Reject a partner request
   * @param {AcceptPartnerRequestReq} req The request with the user id to be rejcted as a partner
   * @param {AuthUser} authUser The user on which to perform the action
   */
  public static async rejectPartnerRequest(req: RejectPartnerRequestReq, authUser: AuthUser): Promise<void> {
    const userDoc = await this.getUserDoc(authUser.id);
    const userData: FirebaseUser = userDoc.data()! as FirebaseUser;

    const partnerDoc = await admin.firestore().collection(FirebaseCollections.users).doc(req.partnerId).get();

    if (partnerDoc.exists) {
      const idIndex = userData.pr?.findIndex((x) => x === partnerDoc.id);
      if (idIndex !== undefined && idIndex !== -1) {
        userData.pr!.splice(idIndex, 1);
        userDoc.ref.update(UserMapper.getModelToUpdatePartnerRequests(userData.pr!));
      }
    }
  }

  /**
   * Remove the current partner of the given user
   * @param {AuthUser} authUser The user on which to perform the action
   */
  public static async removePartner(authUser: AuthUser) {
    const userDoc = await this.getUserDoc(authUser.id);
    const userData: FirebaseUser = userDoc.data()! as FirebaseUser;

    if (userData.p !== undefined) {
      const modelToRemovePartner = UserMapper.getModelToRemovePartner();

      const partnerDoc = await admin.firestore().collection(FirebaseCollections.users).doc(userData.p).get();

      if (partnerDoc.exists) {
        partnerDoc.ref.update(modelToRemovePartner);

        NotificationsController.send(
            "Partner removed you!",
            `${userData.n} removed you as a partner`,
            new RemoteMessageData(RemoteMessageType.partnerRemoved),
            partnerDoc,
            authUser,
        );
      }

      userDoc.ref.update(modelToRemovePartner);
    } else {
      throw new Error(errorCodes.user.noPartner);
    }
  }

  /**
   * Save the given messaging token on the given user
   * The token will be delete if it will be result wrong on sending a notification message
   * @param {RegisterMessagingTokenReq} req The request with the token to be register
   * @param {AuthUser} authUser The user on which to perform the action
   */
  public static async registerMessagingToken(req: RegisterMessagingTokenReq, authUser: AuthUser): Promise<void> {
    this.checkRegisterOrRemoveMessagingTokenReq(req);

    const userDoc = await this.getUserDoc(authUser.id);
    const userData: FirebaseUser = userDoc.data()! as FirebaseUser;

    if (userData.m !== undefined) {
      const tokenIndex = userData.m.findIndex((x) => x === req.token);
      if (tokenIndex === -1) {
        userData.m.push(req.token);
      }
    } else {
      userData.m = [req.token];
    }

    userDoc.ref.update(UserMapper.getModelToUpdateMessagingTokens(userData.m));
  }

  /**
   * Remove the given messaging token from the given user
   * @param {RemoveMessagingTokenReq} req The request with the token to be register
   * @param {AuthUser} authUser The user on which to perform the action
   */
  public static async removeMessagingToken(req: RemoveMessagingTokenReq, authUser: AuthUser): Promise<void> {
    this.checkRegisterOrRemoveMessagingTokenReq(req);

    const userDoc = await this.getUserDoc(authUser.id);
    const userData: FirebaseUser = userDoc.data()! as FirebaseUser;

    if (userData.m !== undefined) {
      const indexToRemove = userData.m.findIndex((x)=> x === req.token);
      if (indexToRemove !== -1) {
        userData.m.splice(indexToRemove, 1);
      }

      userDoc.ref.update(UserMapper.getModelToUpdateMessagingTokens(userData.m));
    }
  }

  /**
   * Send a reminder notificaiton to the partner of the given user
   * @param {AuthUser} authUser
   */
  public static async sendPartnerNotificationReminder(authUser: AuthUser): Promise<void> {
    const userDoc = await this.getUserDoc(authUser.id);
    const userData: FirebaseUser = userDoc.data() as FirebaseUser;

    if (userData.p !== undefined) {
      // Check if user can send notification
      const lastSentDate = userData.nd?.toDate();
      const now = new Date();
      if (lastSentDate) {
        if (lastSentDate.getFullYear() === now.getFullYear() &&
            lastSentDate.getMonth() === now.getMonth() &&
            lastSentDate.getDate() === now.getDate()
        ) {
          throw new Error(errorCodes.user.reminderAlreadySent);
        }
      }

      const partnerDoc = await admin.firestore().collection(FirebaseCollections.users).doc(userData.p).get();
      if (partnerDoc.exists) {
        NotificationsController.send(
            "Reminder",
            `${userData.n}`,
            new RemoteMessagePartnerReminder(userData.n),
            partnerDoc,
            authUser,
        );
        userDoc.ref.update(UserMapper.getModelToUpdateLastNotificationSentToPartnerTimestamp());
      } else {
        throw new Error(errorCodes.user.partnerNotFound);
      }
    } else {
      throw new Error(errorCodes.user.noPartner);
    }
  }

  /**
   * Return the user firebase doc
   * @param {stirng} userId The id of the user
   * @return {Promise<firestore.DocumentSnapshot<firestore.DocumentData>>}
   */
  public static async getUserDoc(userId: string): Promise<firestore.DocumentSnapshot<firestore.DocumentData>> {
    const userDoc = await admin.firestore().collection(FirebaseCollections.users).doc(userId).get();

    if (userDoc.exists) {
      return userDoc;
    } else {
      throw new Error(errorCodes.user.userNotFound);
    }
  }

  /**
   * Return the partner doc of the given user id
   * @param {string} userId The id of the user
   * @return {Promise<firestore.DocumentSnapshot<firestore.DocumentData>>}
   */
  public static async getPartnerDoc(userId: string): Promise<firestore.DocumentSnapshot<firestore.DocumentData>> {
    const userDoc = await this.getUserDoc(userId);
    const userData = userDoc.data() as FirebaseUser;

    if (userData.p === undefined) {
      throw new Error(errorCodes.user.noPartner);
    }

    const partnerDoc = await admin.firestore().collection(FirebaseCollections.users).doc(userData.p).get();
    if (partnerDoc.exists) {
      return partnerDoc;
    } else {
      throw new Error(errorCodes.user.partnerNotFound);
    }
  }

  private static checkRegisterUserReq(req: RegisterUserReq): void {
    if (req.nickname == null) {
      throw new Error(errorCodes.invalidInput);
    }
  }

  private static checkUpdateNicknameReq(req: UpdateNicknameReq): void {
    if (req.nickname == null) {
      throw new Error(errorCodes.invalidInput);
    }
  }

  private static checkRegisterOrRemoveMessagingTokenReq(req: RegisterMessagingTokenReq | RemoveMessagingTokenReq): void {
    if (req.token == null) {
      throw new Error(errorCodes.invalidInput);
    }
  }
}
