# Presentation materials

- `Prop99_Presentation.qmd`: editable Quarto slide source.
- `Prop99_Presentation.html`: generated browser slide deck.
- `slides.css`: slide formatting used by Quarto.
- `Speaker_Script.md` / `Speaker_Script.html`: narration, speaker allocation, our 40-minute Tuesday plan, and step-by-step Zoom recording instructions.
- `Presentation_QA.md`: likely questions, short answers, and limits on what our checks establish.

## Open and review

1. Open `Replication.Rproj` in RStudio.
2. In Files, open `presentation/Prop99_Presentation.html` in a web browser.
3. Use the arrow keys to move between slides. Slides 11–12 are appendices.
4. Open `presentation/Speaker_Script.md` to rehearse alongside the slides.

## Edit and render in RStudio

1. Open `presentation/Prop99_Presentation.qmd`.
2. Edit the slide text, then save.
3. Click Render. The QMD reads the saved result CSVs; it does not refit models.
4. Review the resulting HTML. Keep `slides.css` beside the QMD.

From the repository root, the equivalent command is:

```sh
quarto render presentation/Prop99_Presentation.qmd
```

## Before recording

Slide 10 gives a general methodological connection. The assignment requests a connection to the proposed final project, so confirm that the spoken explanation addresses the project you and Ying actually plan to undertake.

The speaker split is a suggestion. Ying covers slides 1–4, Feng Yi covers slides 5–10. Aim for 9–10 minutes in a timed rehearsal. The script's timing is an estimate, not a measured recording.

Share the browser presentation in a recording application that both presenters can access, with microphone audio enabled. Choose the application together. Make a short test recording to check text readability, audio from both speakers, and slide transitions. Then record the full presentation and check its duration and playback. Confirm the instructor's required submission format before submitting.

## Collaboration

Use the existing repository as the shared folder once collaborator access is active. Until then, these files are local. Publishing the branch uploads commits. A pull request lets Ying review them before merging. Commit related edits together. Coordinate who edits the QMD to reduce conflicts, or use separate branches. The HTML is generated output, so edit the QMD and render it rather than editing HTML directly.

No recording or final submission occurs automatically. No invitations or messages have been sent by these files.
