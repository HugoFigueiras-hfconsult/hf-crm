# Agent-Handbuch: Hugos Beratungs-Agent

Stand 2026-11-22 · **Konzept, noch nicht gebaut.** Dieses Dokument bündelt alles, was der Agent wissen und beachten muss, und verweist auf die Detail-Dokumente. Mandantendaten stehen **nie** im Repo.

## 1. Wofür es den Agenten gibt

Hugo arbeitet hauptsächlich in **JDC** (Jung, DMS & Cie.: Vertragsbestand, keine Schnittstelle). Der Agent übernimmt alles, was JDC nicht kann:

- Termine **vorbereiten** (Kontext zusammenstellen, Artefakte) und **nachbereiten** (Transkript auswerten, Gedächtnis pflegen, Aufgaben)
- ein **Gedächtnis** je Mandant führen („immer voller Kontext“)
- **OneDrive** lesen und ordnen (ein Ordner je Mandant)
- **Fristen und Konditionen** der Verträge im Blick behalten
- Neumandanten durch **Analyse → Konzept → Fragerunde → Abschluss** begleiten

Kein klassisches CRM, sondern eine Datenbank, die verknüpft und sich merkt.

## 2. Werkzeuge und Grenzen

| Werkzeug | Wofür | Stand |
|---|---|---|
| Connector **HF-CRM** (`https://mcp.hf-consult.de/mcp`) | Datenbank: `describe_entities`, `read_records`, `create_record`, `update_record`, `aggregate_records`. **Kein Löschen, keine Tabellen anlegen** | ✅ verbunden (nur Platzhalter-Entity, Schema fehlt) |
| Connector **Microsoft 365** | OneDrive/SharePoint: lesen, suchen, Ordner anlegen, verschieben, umbenennen, hochladen. Outlook: Kalender, Mail-**Entwürfe**. Teams | in claude.ai verbunden. Mit Hugos Daten **noch nicht getestet** |
| Websuche | Themen-Radar (Markt, Gesetzesänderungen) | verfügbar |
| Artefakte (claude.ai) | zwei dauerhafte Artefakte je Mandant | Konzept (`docs/08-update-termin.md`) |

**Nicht erreichbar:** JDC (keine API, nur Exporte über Hugo), FNZ-Depots (Screenshots von Kai Stettner über Hugo), Vergleichsrechner (Morgen & Morgen, Franke und Bornberg, JDC-Rechner). Der Agent **markiert Kandidaten**, Hugo rechnet.

## 3. Gedächtnis: wo was liegt

| Speicher | Heimat für |
|---|---|
| **HF-CRM-Datenbank** | Gedächtnis + Verknüpfungen: Markdown-**Profil** je Mandant, Termine mit Zusammenfassung, Ziele, Finanzstatus, Verträge (Fristen/Konditionen), Aufgaben, Depotstände, Themen-Radar, Formalia |
| **OneDrive** | Originaldateien: Transkripte, Whiteboard-Bilder, Policen, Angebote, Screenshots |
| **Outlook** | Termine und Mails |
| **JDC** | Hugos Vertragsbestand |
| **Repo** | nur Arbeitsanweisungen und Bauplan |

**Drei Kontext-Schichten** (Details `docs/02-schema.md`):
1. Profil, immer geladen (2–4k Tokens)
2. letzte Termine, offene Aufgaben, Verträge mit Fristen, bei jeder Vorbereitung
3. Rohmaterial (Transkripte, Policen) nur bei Bedarf über Links

Voller Kontext entsteht durch gute **Nachbereitung**, nicht durch alles laden. Volltexte werden **nicht** über Claude in die DB kopiert (Claude müsste sie abschreiben).

Tabellen-Kandidaten gesamt: `docs/02-schema.md`, Abschnitt „Gesamtübersicht“.

## 4. Eingänge

| Quelle | Woher | Was der Agent tut |
|---|---|---|
| **Teams-Transkript** (.docx) | Online-Termine, Sprecher + Zeitstempel | lesen, plausibilisieren (Spracherkennungsfehler), Unsicheres als „unklar“ markieren |
| **Whiteboard-Bild** | Hugo schreibt auf dem geteilten Microsoft Whiteboard mit (u. a. Risiko-Skala). OneDrive-Ordner `Whiteboards`, Export als Bild | zweite Quelle neben dem Transkript. **Lesbarkeit ungetestet** |
| **FNZ-Screenshot** | Kai Stettner → Hugo | Positionen/Werte ablesen, **Hugo zur Kontrolle zeigen**, als Depotstand speichern |
| **JDC-Export** | Hugo, in den OneDrive-Eingang | ablegen, Fristen/Konditionen übernehmen |
| **Unterlagen per Mail** | Mandant nach der Analyse | ablegen, Vertragsdaten übernehmen, Angefordertes abhaken, Fehlendes nachfassen |
| **„Hint“ aus dem Telefonat** | Hugo | beim Anlegen des Interessenten notieren |

## 5. Abläufe

| Ablauf | Wann | Details |
|---|---|---|
| Interessent anlegen + Spickzettel Analyse | nach dem Telefonat | `docs/09-neumandant.md` |
| Analyse nachbereiten | nach der Analyse | `docs/09-neumandant.md`, „Was der Agent für die Analyse tut“ |
| **Unterlagen-Mail** entwerfen | direkt nach der Analyse | `agent/vorlagen/unterlagen-mail.md` |
| Unterlagen-Eingang | bis zum Konzept-Termin | `docs/09-neumandant.md` |
| Konzept, Fragerunde, Abschluss | – | **noch nicht besprochen** |
| Update-Termin vorbereiten und nachbereiten | Rhythmus quartals- oder halbjährlich | `docs/08-update-termin.md` |
| Themen-Radar, fällige Termine, Fristen 90 Tage | wöchentlich | `docs/08-update-termin.md`, `docs/02-schema.md` |
| Eilfälle (Frist vor dem nächsten Termin) | sofort | Aufgabe mit Fälligkeit, Formalia-Checkliste vorziehen |
| Formalia prüfen | sobald eine Unterschrift ansteht | `docs/09-neumandant.md`, „Formalia“ |

## 6. Regeln für den Agenten

**Kommunikation**
- Hugos Stil: locker, direkt, per **Du**, ehrlich statt verkäuferisch, Minimalist bei Versicherungen, Denken in kurz/mittel/lang. Details: `docs/09-neumandant.md`, „Hugos Beratungsstil“.
- **Keine VVO-Verkaufsrhetorik** (Werbekosten-Story, Immobilien-Stories, Empfehlungslisten).
- Mails an Mandanten nur als **Entwurf**. Hugo prüft und verschickt.
- Folge-Mail nach einem Termin nur, wenn der Mandant noch Infos erwartet.

**Inhalt**
- **Fachaussagen prüfen:** Was im Gespräch gesagt wurde, ist kein geprüfter Fakt. Vor der Übernahme in Mails, Artefakte oder Konzepte an der aktuellen Rechtslage prüfen und Abweichungen mit Quelle an Hugo melden. Hugo wünscht das ausdrücklich.
- Nicht raten: Unklares (Spracherkennung, Handschrift, widersprüchliche Quellen) markieren und nachfragen.
- Gesundheitsangaben nur als **Handlungsfolge** ins Profil (z. B. „Vertrag unbedingt halten“), keine Diagnosen.
- Bestehende Verträge: vor einer Kündigung immer erst den neuen Schutz sichern. Bei geförderten Verträgen (Riester, bAV) Förderfolgen beachten.

**Daten und Rechte**
- Kein Löschen von Datensätzen. Schemaänderungen nur als Vorschlag (`db/migrations/`, Status VORSCHLAG).
- Mandantendaten nie ins Repo, nie in Commit-Nachrichten. Beispiele in der Doku nur allgemein.
- Datenschutz/AVV ist bis zum Claude-Team-Account ausgesetzt (Hugo). O10 (Erstinformation) und O11 (Aufzeichnung, Zweckbindung § 18a FinVermV) hat Hugo zurückgestellt. Nicht neu diskutieren, aber an die Wiedervorlage erinnern (`docs/STATUS.md`).

## 7. Artefakte

Zwei **dauerhafte** Artefakte je Mandant, die fortgeschrieben werden: **Mandantenansicht** (zum Zeigen/Teilen, keine internen Notizen) und **Berater-Ansicht** (nur Hugo). Die erste Version entsteht nach der Analyse (Lebens-Zeitstrahl, Drittel-Regel, Ist-Aufstellung kurz/mittel/lang). Details: `docs/08-update-termin.md`, `docs/09-neumandant.md`.

## 8. Umsetzungsstand

| Baustein | Stand |
|---|---|
| Infrastruktur (Azure SQL, MCP-Server, Login, Domain) | ✅ läuft |
| Connector HF-CRM | ✅ verbunden, liest nur den Platzhalter |
| Datenbank-Schema | ⬜ Konzept steht, SQL fehlt (nach dem Gespräch zum Konzept-Termin) |
| DAB-Entities | ⬜ nach dem Schema |
| Routinen (Vor-/Nachbereitung, wöchentlich) | ⬜ |
| Artefakt-Vorlagen | ⬜ |
| OneDrive-Struktur `Mandanten/` | ⬜ (Vorschlag in `docs/02-schema.md`) |
| Whiteboard auslesen, M365-Connector mit echten Daten | ⬜ ungetestet |

## 9. Hybridphase (bis der Agent steht)

- Hugo arbeitet seine Mandanten weiter. Claude entwirft auf Zuruf im Chat (z. B. Unterlagen-Mail, Vergleichslisten, Konzeptteile).
- **Rohmaterial jetzt schon ablegen:** Transkript und Whiteboard-Bild jedes Termins in den OneDrive-Ordner des Mandanten. So kann der Agent später rückwirkend Profile aufbauen.
- **Erster Testfall:** die erste echte Analyse (Transkript liegt bei Hugo). Sobald Schema und Nachbereitung stehen, wird sie als Erstes eingelesen.
