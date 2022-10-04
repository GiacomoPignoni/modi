import admin, { firestore } from "firebase-admin";
import { UserMapper } from "../mappers/user-mapper";
import { AuthUser } from "../models/auth-user";
import { FirebaseUser } from "../models/firebase/user";
import { RemoteMessageData } from "../models/remote-message";
import { Logger } from "../utils/logger";

/**
 * Controller to send notification
 */
export class NotificationsController {
  /**
   * Send a notification to the given user
   *
   * Automatically delete the wrong messaging tokens saved on the user profile
   * @param {string} titleKey The title text of the notification
   * @param {string} bodyKey The body text of the notification
   * @param {RemoteMessageData} data The data of the message
   * @param {firestore.QueryDocumentSnapshot<firestore.DocumentData> | firestore.DocumentSnapshot<firestore.DocumentData>} userDoc The user doc
   * @param {AuthUser} authUser The user to send notification
   */
  public static async send(
      titleKey: string,
      bodyKey: string,
      data: RemoteMessageData,
      userDoc: firestore.QueryDocumentSnapshot<firestore.DocumentData> | firestore.DocumentSnapshot<firestore.DocumentData>,
      authUser: AuthUser,
  ): Promise<void> {
    const userData: FirebaseUser = userDoc.data() as FirebaseUser;

    if (userData && userData.m && userData.m.length > 0) {
      const tokens: (string | null)[] = [...userData.m!];

      const message: admin.messaging.MulticastMessage = {
        notification: {
          title: titleKey,
          body: bodyKey,
        },
        data: data.toMap(),
        tokens: tokens as string[],
      };

      admin.messaging().sendMulticast(message).then((response) => {
        response.responses.forEach((r, index) => {
          if (r.success === false) {
            tokens[index] = null;
            Logger.error(r.error!.message, authUser);
          }
        });

        if (response.failureCount > 0) {
          userDoc.ref.update(UserMapper.getModelToUpdateMessagingTokens(tokens.filter((x) => x !== null) as string[]));
        }
      }).catch((error) => {
        Logger.error(error, authUser);
      });
    }
  }
}
