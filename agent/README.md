# Agent-Handbuch: Hugos Beratungs-Agent

Stand 2026-11-25 · **Konzept, noch nicht gebaut.** Dieses Dokument bündelt alles, was der Agent wissen und beachten muss, und verweist auf die Detail-Dokumente. Mandantendaten stehen **nie** im Repo.

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
| Connector **Microsoft 365** | OneDrive/SharePoint: lesen, suchen, Ordner anlegen, verschieben, umbenennen, hochladen. Outlook: Kalender, Mail-**Entwürfe**. Teams | in claude.ai verbunden. ✅ 2026-11-25 mit echten Daten genutzt (Mails/Anhänge lesen, Ordner anlegen). Upload nur bis 1 MB |
| Websuche | Themen-Radar (Markt, Gesetzesänderungen) | verfügbar |
| Artefakte (claude.ai) | **ein** dauerhaftes Artefakt je Mandant, Hugo präsentiert es per Bildschirmfreigabe, ersetzt die VVO-Präsentation | Konzept (`docs/10-mandanten-artefakt.md`), Vorlage noch nicht gebaut |
| **Claude in Chrome** (Browser-Erweiterung in Hugos Edge) | JDC iCRM (Interessenten anlegen), **NAFI-KFZ-Rechner** und **Morgen & Morgen** (BU) bedienen, wenn Hugo angemeldet ist und den Tab in die Tab-Gruppe des Agenten zieht. Anleitungen: `agent/portale/jdc-nafi-kfz.md`, `agent/portale/jdc-mm-bu.md` | ✅ erprobt 2026-11-25 (Kfz-Wechselvergleich, BU-Vergleich mit PDF) |

**Nicht erreichbar:** JDC per API (keine Schnittstelle), FNZ-Depots (Screenshots von Kai Stettner über Hugo), Vergleichsrechner außer NAFI-KFZ (Morgen & Morgen, Franke und Bornberg, übrige JDC-Rechner noch nicht erprobt), die **VVO-Präsentation** im Konzept-Termin (der Agent liefert Hugo die Zahlen, Hugo trägt sie ein). Dort **markiert der Agent Kandidaten**, Hugo rechnet. **Über den Browser erreichbar** (seit 2026-11-25): JDC iCRM und NAFI-KFZ, siehe Claude in Chrome oben. Login, Antrag, eVB und Kündigung bleiben bei Hugo.

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
| Konzept vorbereiten (Zahlen-Spickzettel, „vor Optimierung“, Vergleichsvorgaben, Rentenlücke) | wenn die Unterlagen da sind | `docs/09-neumandant.md`, „Was der Agent für Konzept und Fragerunde tut“ |
| Konzept nachbereiten (Stand je Vorschlag, Mail-Entwurf mit PDFs, Fragerunde) | nach dem Konzept-Termin | ebd. + `agent/vorlagen/konzept-mail.md` |
| Abschluss vorbereiten/nachbereiten (Formalia, Anträge, Police prüfen, Altverträge erst danach kündigen, Bestand) | Unterschriften-Termin | `docs/09-neumandant.md`, „Abschluss“ |
| Empfehlungen (früh ankündigen, Anlässe im Briefing, Text zum Weiterleiten, Danke) | jeder Termin | `docs/09-neumandant.md`, „Empfehlungen“, `agent/vorlagen/empfehlung-weiterleiten.md` |
| Update-Termin vorbereiten und nachbereiten | Rhythmus quartals- oder halbjährlich | `docs/08-update-termin.md` |
| Themen-Radar, fällige Termine, Fristen 90 Tage | wöchentlich | `docs/08-update-termin.md`, `docs/02-schema.md` |
| Eilfälle (Frist vor dem nächsten Termin) | sofort | Aufgabe mit Fälligkeit, Formalia-Checkliste vorziehen |
| Formalia prüfen | sobald eine Unterschrift ansteht | `docs/09-neumandant.md`, „Formalia“ |
| **Kfz-Vergleich** (Interessent in JDC anlegen, NAFI rechnen, Vergleich speichern, Ergebnis für Hugo aufbereiten) | Unterlagen da, Frist 30.11. bzw. Beitragserhöhung | `agent/portale/jdc-nafi-kfz.md` |
| **BU-Vergleich / Gegenangebot prüfen** (M&M rechnen mit gleicher Rente und gleichem Endalter, PDF, Prüfung in den Mandantenordner) | Konzept oder Gegenangebot eines Mitbewerbers | `agent/portale/jdc-mm-bu.md` |

## 6. Regeln für den Agenten

**Kommunikation**
- Hugos Stil: locker, direkt, per **Du**, ehrlich statt verkäuferisch, Minimalist bei Versicherungen, Denken in kurz/mittel/lang. Details: `docs/09-neumandant.md`, „Hugos Beratungsstil“.
- **Keine VVO-Verkaufsrhetorik** (Werbekosten-Story, Immobilien-Stories, Empfehlungslisten, Zustimmungsfragen, „Abschluss heute“).
- **Empfohlene Personen nie ungefragt anrufen oder anschreiben** (§ 7 UWG). Sie melden sich selbst über den weitergeleiteten Text (`agent/fachwissen.md` Abschnitt 8).
- **VVO-Leitfäden sind verkaufsgetrieben und teils falsch** (Beratungsgespräch Stand 2018): weder Aussagen noch Formulierungen übernehmen. Richtige Sachverhalte, Zahlen 2026, Rechenregeln und Sprachregeln: **`agent/fachwissen.md`**.
- **Transkripte immer auf fachliche Fehler prüfen**, auch ungefragt, und die Korrektur mit Primärquelle nennen (Hugo, 2026-11-25). Bekannte Fehlaussagen und die Kennzahlen für den Termin: `agent/fachwissen.md` Abschnitte 9 und 10.
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

**1 Mandant = 1 Artefakt** (Hugo, 2026-11-25): vom Agenten erstellt und fortgeschrieben, Hugo präsentiert es **nur per Bildschirmfreigabe** in Analyse, Konzept und Update-Terminen. Es ersetzt langfristig die VVO-Präsentation, muss visuell hochwertig und animiert sein und enthält **nie interne Notizen** (der Mandant sieht mit). Hugos interne Infos kommen als **Briefing im Chat**. Der Mandant bekommt keinen Link, sondern am Ende die Mail mit den PDFs. Details: `docs/10-mandanten-artefakt.md`.

## 8. Umsetzungsstand

| Baustein | Stand |
|---|---|
| Infrastruktur (Azure SQL, MCP-Server, Login, Domain) | ✅ läuft |
| Connector HF-CRM | ✅ verbunden, liest nur den Platzhalter |
| Datenbank-Schema | 🟡 v1 als Vorschlag (`db/migrations/001_init.sql`, getestet), wartet auf Hugos Freigabe |
| DAB-Entities | ⬜ nach dem Schema |
| Routinen (Vor-/Nachbereitung, wöchentlich) | ⬜ |
| Artefakt-Vorlagen | ⬜ |
| OneDrive-Struktur `Mandanten/` | 🟡 Hugo nutzt `Dokumente/VVO Finance/Mandanten/<Vorname Nachname>/` mit `Unterlagen Analyse/` und `Unterlagen Konzept/` (seit 2026-11-25, Altbestand wird per Copilot-Agent umsortiert). Abgleich mit Vorschlag in `docs/02-schema.md` offen |
| Whiteboard auslesen | ⬜ ungetestet (.whiteboard-Datei kann der M365-Connector nicht lesen, Export als Bild nötig) |
| M365-Connector mit echten Daten | ✅ 2026-11-25: Mails + Anhänge (PDF, Bild) lesen, OneDrive-Ordner anlegen. Upload nur bis 1 MB |
| JDC iCRM + NAFI-KFZ per Claude in Chrome | ✅ 2026-11-25 erprobt (`agent/portale/jdc-nafi-kfz.md`) |
| Morgen & Morgen (BU) per Claude in Chrome, PDF-Download | ✅ 2026-11-25 erprobt (`agent/portale/jdc-mm-bu.md`) |

## 9. Hybridphase (bis der Agent steht)

- Hugo arbeitet seine Mandanten weiter. Claude entwirft auf Zuruf im Chat (z. B. Unterlagen-Mail, Vergleichslisten, Konzeptteile).
- **Profil vorläufig als Datei** (seit 2026-11-25): Solange es kein DB-Schema gibt, schreibt Claude das Mandantenprofil als Markdown `Profil <Vorname Nachname>.md` direkt in den OneDrive-Mandantenordner. Aufbau wie das spätere `Mandant.Profil`: Kurzprofil, Beruf/Einkommen, Familie, Hobbys/Risiken, Haltung zu Finanzen, Ziele, Finanzstatus, Verträge, **Was erklärt wurde** (mit Datum), Fachhinweise, offene Aufgaben. Gesundheit nur als Handlungsfolge. Der Agent liest diese Datei **zuerst**, bevor er zu einem Mandanten arbeitet, und übernimmt sie später in die DB.
- **Rohmaterial jetzt schon ablegen:** Transkript und Whiteboard-Bild jedes Termins in den OneDrive-Ordner des Mandanten. So kann der Agent später rückwirkend Profile aufbauen.
- **Erster Testfall:** die erste echte Analyse (Transkript liegt bei Hugo). Sobald Schema und Nachbereitung stehen, wird sie als Erstes eingelesen.
