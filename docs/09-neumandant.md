# Neue Mandanten: Prozess (Entwurf, Gespräch am 2026-11-13)

Stand 2026-11-12 · **Nur der grobe Rahmen von Hugo.** Was in den einzelnen Terminen passiert, wird am 2026-11-13 besprochen. Danach: Felder/Workflows ergänzen und erst dann `db/migrations/001_init.sql` (Hugo: „wenn wir das alles durchgesprochen haben … dann schießen wir los“).

## Rahmen (Hugo, 2026-11-12)

1. **Zugang:** fast immer über **Empfehlung**, von bestehenden Mandanten oder Freunden.
2. **Kurzes Telefonat:** Termin vereinbaren + kurzer „Hint“, worum es geht.
3. **Termine:** meist **online**, auf ausdrücklichen Wunsch im angemieteten Büro.
   1. **Analyse**
   2. **Konzeptvorstellung / Beratung**
   3. **Fragerunde**
   4. Danach: wenn alles klar ist → **Unterschriften**, sonst weitere Fragerunden.

## Offene Fragen für das Gespräch am 2026-11-13 (Vorschlag Agent)

- Was passiert in **Analyse**, **Konzept**, **Fragerunde** jeweils konkret? Was bringt der Mandant mit, was bereitest du vor, was entsteht danach (Unterlagen, Angebote, Konzept-Dokument)?
- Was soll der Agent zwischen den Terminen tun (z. B. Analyse-Ergebnisse strukturieren, Konzept-Entwurf vorbereiten, Fragen sammeln, Unterlagen nachfordern)?
- Wann wird aus dem Interessenten ein Mandant (OneDrive-Ordner, Profil, JDC-Anlage)? Was passiert, wenn jemand abspringt?
- Wie wird festgehalten, **wer empfohlen hat**, und soll es eine Danke-Geste an Empfehlungsgeber geben?
- Wo kommt der „Hint“ aus dem Telefonat hin (Notiz vorm ersten Termin)?
- Übergang in die Update-Termine (`docs/08-update-termin.md`): ab wann, welcher Rhythmus am Anfang?
- Rolle der zwei Artefakte (Mandanten- und Berater-Ansicht) schon in Analyse/Konzept?

## Vermutliche Auswirkungen aufs Datenmodell (noch nicht entschieden)

- `Mandant.EmpfohlenVon` (Verweis auf einen anderen Mandanten oder Freitext) und `Mandant.Quelle` (Empfehlung/sonstiges).
- Phasen im `Mandant.Status`: Interessent → Analyse → Konzept → Fragerunde → Abschluss → Bestand (oder abgesprungen).
- `Termin.Art` um Analyse / Konzept / Fragerunde / Unterschrift erweitern, `Termin.Ort` (online/Büro).
- `Mandant.Erstkontakt` (Hint aus dem Telefonat).
