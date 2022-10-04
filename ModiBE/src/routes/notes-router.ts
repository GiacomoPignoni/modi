import { Router } from "express";
import { firebaseJwtAuth } from "../middlewares/firebase-jwt-auth";
import { NotesController } from "../controllers/notes-controller";
import { GetAvailableYearsRes, GetManyNotesRes } from "../models/res/note-reses";
import { action } from "./base-action";

export const notesRouter = Router();

notesRouter.get("/many", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const notes = await NotesController.getMany(req.query["dateFrom"] as string, req.query["dateTo"] as string, res.locals.authUser);
    res.send(new GetManyNotesRes(notes));
  });
});

notesRouter.get("/partner/:year", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const notes = await NotesController.getPartnerNotesPerYear(parseInt(req.params["year"]), res.locals.authUser);
    res.send(new GetManyNotesRes(notes));
  });
});

notesRouter.get("/available-years", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const years = await NotesController.getAvailableYears(res.locals.authUser);
    res.send(new GetAvailableYearsRes(years));
  });
});

notesRouter.post("/add", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const addNoteRes = await NotesController.add(req.body, res.locals.authUser);
    res.send(addNoteRes);
  });
});

notesRouter.put("/update", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const updateNoteRes = await NotesController.update(req.body, res.locals.authUser);
    res.send(updateNoteRes);
  });
});

notesRouter.delete("/delete/:id", firebaseJwtAuth, async (req, res) => {
  action(res, async () => {
    const baseRes = await NotesController.delete(req.params["id"], res.locals.authUser);
    res.send(baseRes);
  });
});
