-- STATUS: VORSCHLAG
-- ZWECK: Erstes Schema für das HF-CRM (Gedächtnis + Verknüpfung für Hugos Beratungs-Agenten).
--        10 Tabellen: Mandant, Termin, Ziel, Finanzstatus, Vertrag, Aufgabe, Formalie,
--        Depotstand, DepotPosition, Thema. Fachliche Beschreibung: docs/02-schema.md, Abschnitt "Entitäten".
--
-- Regeln (CLAUDE.md, docs/02-schema.md):
--   - Nur Standardtypen, Primärschlüssel je Tabelle, keine Trigger/Funktionen/Prozeduren.
--   - Logik (z. B. GeaendertAm setzen, Status-Übergänge) macht der Agent.
--   - Auswahlwerte bewusst OHNE Umlaute (technisch robuster), z. B. 'uebergeben', 'gekuendigt'.
--     Erlaubte Werte stehen als CHECK-Regel hier und als Beschreibung in docs/02-schema.md.
--     Einen neuen Wert erlauben = neue Migration.
--   - Geldbeträge in EUR, Finanzstatus-Beträge pro Monat.
--   - ErstelltAm/GeaendertAm in UTC; Termin.Beginn in deutscher Ortszeit.
--   - Idempotent: Tabellen/Indizes werden nur angelegt, wenn sie fehlen. Ein einziger Block ohne GO,
--     damit es auch im Abfrage-Editor des Azure-Portals läuft.

SET XACT_ABORT ON;
BEGIN TRANSACTION;

-------------------------------------------------------------------------------
-- Mandant: wer, wo liegt was, Gedächtnis (Profil)
-------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.Mandant', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Mandant (
        MandantId              UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Mandant_Id DEFAULT NEWID(),
        Anzeigename            NVARCHAR(200)    NOT NULL,
        Art                    NVARCHAR(20)     NOT NULL CONSTRAINT DF_Mandant_Art DEFAULT N'Haushalt',
        Status                 NVARCHAR(20)     NOT NULL CONSTRAINT DF_Mandant_Status DEFAULT N'Interessent',
        StatusSeit             DATE             NULL,
        EMail                  NVARCHAR(254)    NULL,
        Geburtsjahr            SMALLINT         NULL,
        Schwerpunkt            NVARCHAR(20)     NULL,
        Risikoprofil           TINYINT          NULL,
        RisikoprofilAm         DATE             NULL,
        RisikoprofilQuelle     NVARCHAR(1000)   NULL,
        EmpfohlenVonMandantId  UNIQUEIDENTIFIER NULL,
        EmpfohlenVonText       NVARCHAR(200)    NULL,
        Quelle                 NVARCHAR(30)     NULL,
        Erstkontakt            NVARCHAR(1000)   NULL,
        OneDriveOrdnerId       NVARCHAR(200)    NULL,
        OneDriveOrdnerPfad     NVARCHAR(500)    NULL,
        JdcKundennummer        NVARCHAR(50)     NULL,
        VvoKundennummer        NVARCHAR(50)     NULL,
        Profil                 NVARCHAR(MAX)    NULL,
        ProfilStand            DATETIME2(0)     NULL,
        Terminrhythmus         NVARCHAR(20)     NULL,
        ArtefaktUrl            NVARCHAR(500)    NULL,
        ErstelltAm             DATETIME2(0)     NOT NULL CONSTRAINT DF_Mandant_ErstelltAm DEFAULT SYSUTCDATETIME(),
        GeaendertAm            DATETIME2(0)     NULL,
        CONSTRAINT PK_Mandant PRIMARY KEY (MandantId),
        CONSTRAINT FK_Mandant_EmpfohlenVon FOREIGN KEY (EmpfohlenVonMandantId) REFERENCES dbo.Mandant (MandantId),
        CONSTRAINT CK_Mandant_Art CHECK (Art IN (N'Person', N'Haushalt', N'Firma')),
        CONSTRAINT CK_Mandant_Status CHECK (Status IN (N'Interessent', N'Analyse', N'Konzept', N'Fragerunde',
                                                       N'Abschluss', N'Bestand', N'abgesprungen', N'inaktiv')),
        CONSTRAINT CK_Mandant_Schwerpunkt CHECK (Schwerpunkt IS NULL OR Schwerpunkt IN (N'Versicherung', N'Investment', N'beides')),
        CONSTRAINT CK_Mandant_Risikoprofil CHECK (Risikoprofil IS NULL OR Risikoprofil BETWEEN 1 AND 10),
        CONSTRAINT CK_Mandant_Terminrhythmus CHECK (Terminrhythmus IS NULL OR Terminrhythmus IN (N'Quartal', N'Halbjahr', N'Jahr'))
    );
END;

-------------------------------------------------------------------------------
-- Termin: jeder Kontakt mit Vor- und Nachbereitung
-------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.Termin', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Termin (
        TerminId        UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Termin_Id DEFAULT NEWID(),
        MandantId       UNIQUEIDENTIFIER NOT NULL,
        Beginn          DATETIME2(0)     NOT NULL,
        Art             NVARCHAR(20)     NOT NULL,
        Ort             NVARCHAR(20)     NULL,
        Status          NVARCHAR(20)     NOT NULL CONSTRAINT DF_Termin_Status DEFAULT N'geplant',
        OutlookEventId  NVARCHAR(300)    NULL,
        Vorbereitung    NVARCHAR(4000)   NULL,
        Zusammenfassung NVARCHAR(MAX)    NULL,
        Ergebnisse      NVARCHAR(4000)   NULL,
        TranskriptLink  NVARCHAR(1000)   NULL,
        WhiteboardLink  NVARCHAR(1000)   NULL,
        ErstelltAm      DATETIME2(0)     NOT NULL CONSTRAINT DF_Termin_ErstelltAm DEFAULT SYSUTCDATETIME(),
        GeaendertAm     DATETIME2(0)     NULL,
        CONSTRAINT PK_Termin PRIMARY KEY (TerminId),
        CONSTRAINT FK_Termin_Mandant FOREIGN KEY (MandantId) REFERENCES dbo.Mandant (MandantId),
        CONSTRAINT CK_Termin_Art CHECK (Art IN (N'Telefonat', N'Analyse', N'Konzept', N'Fragerunde', N'Unterschrift',
                                                N'Update', N'Beratung')),
        CONSTRAINT CK_Termin_Ort CHECK (Ort IS NULL OR Ort IN (N'online', N'Buero', N'Telefon')),
        CONSTRAINT CK_Termin_Status CHECK (Status IN (N'geplant', N'vorbereitet', N'durchgefuehrt', N'nachbereitet', N'abgesagt'))
    );
    CREATE INDEX IX_Termin_Mandant ON dbo.Termin (MandantId, Beginn);
END;

-------------------------------------------------------------------------------
-- Ziel: Hugos drei Töpfe kurz / mittel / lang
-------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.Ziel', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Ziel (
        ZielId       UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Ziel_Id DEFAULT NEWID(),
        MandantId    UNIQUEIDENTIFIER NOT NULL,
        Topf         NVARCHAR(10)     NOT NULL,
        Beschreibung NVARCHAR(500)    NOT NULL,
        Betrag       DECIMAL(12,2)    NULL,
        Jahr         SMALLINT         NULL,
        Status       NVARCHAR(20)     NOT NULL CONSTRAINT DF_Ziel_Status DEFAULT N'offen',
        Notiz        NVARCHAR(1000)   NULL,
        ErstelltAm   DATETIME2(0)     NOT NULL CONSTRAINT DF_Ziel_ErstelltAm DEFAULT SYSUTCDATETIME(),
        GeaendertAm  DATETIME2(0)     NULL,
        CONSTRAINT PK_Ziel PRIMARY KEY (ZielId),
        CONSTRAINT FK_Ziel_Mandant FOREIGN KEY (MandantId) REFERENCES dbo.Mandant (MandantId),
        CONSTRAINT CK_Ziel_Topf CHECK (Topf IN (N'kurz', N'mittel', N'lang')),
        CONSTRAINT CK_Ziel_Status CHECK (Status IN (N'offen', N'erreicht', N'verworfen'))
    );
    CREATE INDEX IX_Ziel_Mandant ON dbo.Ziel (MandantId);
END;

-------------------------------------------------------------------------------
-- Finanzstatus: Einkommen, Drittel-Regel, Sparraten, Rentenlücke je Stichtag (Beträge pro Monat)
-------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.Finanzstatus', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Finanzstatus (
        FinanzstatusId    UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Finanzstatus_Id DEFAULT NEWID(),
        MandantId         UNIQUEIDENTIFIER NOT NULL,
        Stichtag          DATE             NOT NULL,
        Brutto            DECIMAL(12,2)    NULL,
        Steuer            DECIMAL(12,2)    NULL,
        AbgabenAV         DECIMAL(12,2)    NULL,
        AbgabenKVPV       DECIMAL(12,2)    NULL,
        AbgabenRV         DECIMAL(12,2)    NULL,
        NettoVon          DECIMAL(12,2)    NULL,
        NettoBis          DECIMAL(12,2)    NULL,
        Nebeneinkommen    DECIMAL(12,2)    NULL,
        Wohnkosten        DECIMAL(12,2)    NULL,
        Lebenshaltung     DECIMAL(12,2)    NULL,
        Verbindlichkeiten DECIMAL(12,2)    NULL,
        Ruecklage         DECIMAL(12,2)    NULL,
        SparrateKurz      DECIMAL(12,2)    NULL,
        SparrateMittel    DECIMAL(12,2)    NULL,
        SparrateLang      DECIMAL(12,2)    NULL,
        RenteLautInfo     DECIMAL(12,2)    NULL,
        RenteninfoStand   DATE             NULL,
        Rentenbeginn      SMALLINT         NULL,
        BedarfImAlter     DECIMAL(12,2)    NULL,
        Rentenluecke      DECIMAL(12,2)    NULL,
        Annahmen          NVARCHAR(1000)   NULL,
        Notiz             NVARCHAR(2000)   NULL,
        ErstelltAm        DATETIME2(0)     NOT NULL CONSTRAINT DF_Finanzstatus_ErstelltAm DEFAULT SYSUTCDATETIME(),
        GeaendertAm       DATETIME2(0)     NULL,
        CONSTRAINT PK_Finanzstatus PRIMARY KEY (FinanzstatusId),
        CONSTRAINT FK_Finanzstatus_Mandant FOREIGN KEY (MandantId) REFERENCES dbo.Mandant (MandantId)
    );
    CREATE INDEX IX_Finanzstatus_Mandant ON dbo.Finanzstatus (MandantId, Stichtag);
END;

-------------------------------------------------------------------------------
-- Vertrag: bestehende Verträge (eigene + fremde), Vorschläge aus dem Konzept, Fristen und Konditionen
-------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.Vertrag', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Vertrag (
        VertragId        UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Vertrag_Id DEFAULT NEWID(),
        MandantId        UNIQUEIDENTIFIER NOT NULL,
        Bereich          NVARCHAR(20)     NULL,
        Topf             NVARCHAR(10)     NULL,
        Sparte           NVARCHAR(100)    NOT NULL,
        Gesellschaft     NVARCHAR(150)    NULL,
        Tarif            NVARCHAR(200)    NULL,
        Vertragsnummer   NVARCHAR(100)    NULL,
        Beginn           DATE             NULL,
        Ablauf           DATE             NULL,
        KuendigungBis    DATE             NULL,
        Beitrag          DECIMAL(12,2)    NULL,
        Zahlweise        NVARCHAR(20)     NULL,
        KonditionenKurz  NVARCHAR(1000)   NULL,
        Status           NVARCHAR(20)     NOT NULL CONSTRAINT DF_Vertrag_Status DEFAULT N'aktiv',
        Betreuung        NVARCHAR(10)     NULL,
        Hinweis          NVARCHAR(1000)   NULL,
        Quelle           NVARCHAR(20)     NULL,
        QuelleLink       NVARCHAR(1000)   NULL,
        StandVom         DATE             NULL,
        ErsetztVertragId UNIQUEIDENTIFIER NULL,
        Variante         NVARCHAR(20)     NULL,
        TerminId         UNIQUEIDENTIFIER NULL,
        VergleichLink    NVARCHAR(1000)   NULL,
        ErstelltAm       DATETIME2(0)     NOT NULL CONSTRAINT DF_Vertrag_ErstelltAm DEFAULT SYSUTCDATETIME(),
        GeaendertAm      DATETIME2(0)     NULL,
        CONSTRAINT PK_Vertrag PRIMARY KEY (VertragId),
        CONSTRAINT FK_Vertrag_Mandant FOREIGN KEY (MandantId) REFERENCES dbo.Mandant (MandantId),
        CONSTRAINT FK_Vertrag_Ersetzt FOREIGN KEY (ErsetztVertragId) REFERENCES dbo.Vertrag (VertragId),
        CONSTRAINT FK_Vertrag_Termin FOREIGN KEY (TerminId) REFERENCES dbo.Termin (TerminId),
        CONSTRAINT CK_Vertrag_Bereich CHECK (Bereich IS NULL OR Bereich IN (N'Gesundheit', N'Basisrisiken', N'Einkommen',
                                                                           N'Wohnen', N'Kapital')),
        CONSTRAINT CK_Vertrag_Topf CHECK (Topf IS NULL OR Topf IN (N'kurz', N'mittel', N'lang')),
        CONSTRAINT CK_Vertrag_Zahlweise CHECK (Zahlweise IS NULL OR Zahlweise IN (N'monatlich', N'vierteljaehrlich',
                                                                                 N'halbjaehrlich', N'jaehrlich', N'einmalig')),
        CONSTRAINT CK_Vertrag_Status CHECK (Status IN (N'aktiv', N'pausiert', N'gekuendigt', N'Vorschlag',
                                                       N'beantragt', N'abgelehnt')),
        CONSTRAINT CK_Vertrag_Betreuung CHECK (Betreuung IS NULL OR Betreuung IN (N'Hugo', N'fremd')),
        CONSTRAINT CK_Vertrag_Quelle CHECK (Quelle IS NULL OR Quelle IN (N'Analyse', N'Dokument', N'JDC', N'Vergleich')),
        CONSTRAINT CK_Vertrag_Variante CHECK (Variante IS NULL OR Variante IN (N'guenstig', N'Preis-Leistung', N'Top'))
    );
    CREATE INDEX IX_Vertrag_Mandant ON dbo.Vertrag (MandantId, Status);
    CREATE INDEX IX_Vertrag_Fristen ON dbo.Vertrag (KuendigungBis, Ablauf);
END;

-------------------------------------------------------------------------------
-- Aufgabe: Fristen, Wiedervorlagen, To-dos, Unterlagen, Fragen, Kündigungen, Empfehlungen
-------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.Aufgabe', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Aufgabe (
        AufgabeId    UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Aufgabe_Id DEFAULT NEWID(),
        MandantId    UNIQUEIDENTIFIER NULL,
        Titel        NVARCHAR(300)    NOT NULL,
        Beschreibung NVARCHAR(2000)   NULL,
        FaelligAm    DATE             NULL,
        Art          NVARCHAR(20)     NOT NULL CONSTRAINT DF_Aufgabe_Art DEFAULT N'To-do',
        Zustaendig   NVARCHAR(10)     NOT NULL CONSTRAINT DF_Aufgabe_Zustaendig DEFAULT N'Hugo',
        VertragId    UNIQUEIDENTIFIER NULL,
        TerminId     UNIQUEIDENTIFIER NULL,
        Status       NVARCHAR(20)     NOT NULL CONSTRAINT DF_Aufgabe_Status DEFAULT N'offen',
        ErledigtAm   DATE             NULL,
        ErstelltAm   DATETIME2(0)     NOT NULL CONSTRAINT DF_Aufgabe_ErstelltAm DEFAULT SYSUTCDATETIME(),
        GeaendertAm  DATETIME2(0)     NULL,
        CONSTRAINT PK_Aufgabe PRIMARY KEY (AufgabeId),
        CONSTRAINT FK_Aufgabe_Mandant FOREIGN KEY (MandantId) REFERENCES dbo.Mandant (MandantId),
        CONSTRAINT FK_Aufgabe_Vertrag FOREIGN KEY (VertragId) REFERENCES dbo.Vertrag (VertragId),
        CONSTRAINT FK_Aufgabe_Termin FOREIGN KEY (TerminId) REFERENCES dbo.Termin (TerminId),
        CONSTRAINT CK_Aufgabe_Art CHECK (Art IN (N'Frist', N'Wiedervorlage', N'To-do', N'Unterlage', N'Frage',
                                                N'Kuendigung', N'Empfehlung')),
        CONSTRAINT CK_Aufgabe_Zustaendig CHECK (Zustaendig IN (N'Hugo', N'Mandant', N'Agent')),
        CONSTRAINT CK_Aufgabe_Status CHECK (Status IN (N'offen', N'erledigt', N'verworfen'))
    );
    CREATE INDEX IX_Aufgabe_Offen ON dbo.Aufgabe (Status, FaelligAm);
    CREATE INDEX IX_Aufgabe_Mandant ON dbo.Aufgabe (MandantId);
END;

-------------------------------------------------------------------------------
-- Formalie: Checkliste vor Unterschriften
-------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.Formalie', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Formalie (
        FormalieId  UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Formalie_Id DEFAULT NEWID(),
        MandantId   UNIQUEIDENTIFIER NOT NULL,
        Art         NVARCHAR(30)     NOT NULL,
        VertragId   UNIQUEIDENTIFIER NULL,
        Status      NVARCHAR(20)     NOT NULL CONSTRAINT DF_Formalie_Status DEFAULT N'offen',
        Datum       DATE             NULL,
        AblageLink  NVARCHAR(1000)   NULL,
        ErstelltAm  DATETIME2(0)     NOT NULL CONSTRAINT DF_Formalie_ErstelltAm DEFAULT SYSUTCDATETIME(),
        GeaendertAm DATETIME2(0)     NULL,
        CONSTRAINT PK_Formalie PRIMARY KEY (FormalieId),
        CONSTRAINT FK_Formalie_Mandant FOREIGN KEY (MandantId) REFERENCES dbo.Mandant (MandantId),
        CONSTRAINT FK_Formalie_Vertrag FOREIGN KEY (VertragId) REFERENCES dbo.Vertrag (VertragId),
        CONSTRAINT CK_Formalie_Art CHECK (Art IN (N'Erstinformation', N'Datenschutz', N'Maklervollmacht',
                                                 N'Geeignetheit', N'Beratungsdokumentation', N'Aufzeichnung')),
        CONSTRAINT CK_Formalie_Status CHECK (Status IN (N'offen', N'uebergeben', N'unterschrieben'))
    );
    CREATE INDEX IX_Formalie_Mandant ON dbo.Formalie (MandantId);
END;

-------------------------------------------------------------------------------
-- Depotstand + DepotPosition: FNZ-Depot je Stichtag (Screenshot über Hugo)
-------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.Depotstand', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Depotstand (
        DepotstandId UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Depotstand_Id DEFAULT NEWID(),
        MandantId    UNIQUEIDENTIFIER NOT NULL,
        Stichtag     DATE             NOT NULL,
        Depotnummer  NVARCHAR(50)     NULL,
        Gesamtwert   DECIMAL(14,2)    NOT NULL,
        Einzahlungen DECIMAL(14,2)    NULL,
        QuelleLink   NVARCHAR(1000)   NULL,
        ErstelltAm   DATETIME2(0)     NOT NULL CONSTRAINT DF_Depotstand_ErstelltAm DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_Depotstand PRIMARY KEY (DepotstandId),
        CONSTRAINT FK_Depotstand_Mandant FOREIGN KEY (MandantId) REFERENCES dbo.Mandant (MandantId)
    );
    CREATE INDEX IX_Depotstand_Mandant ON dbo.Depotstand (MandantId, Stichtag);
END;

IF OBJECT_ID(N'dbo.DepotPosition', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DepotPosition (
        DepotPositionId UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_DepotPosition_Id DEFAULT NEWID(),
        DepotstandId    UNIQUEIDENTIFIER NOT NULL,
        Bezeichnung     NVARCHAR(200)    NOT NULL,
        ISIN            NVARCHAR(12)     NULL,
        Anteile         DECIMAL(18,6)    NULL,
        Wert            DECIMAL(14,2)    NOT NULL,
        Anteil          DECIMAL(5,2)     NULL,
        CONSTRAINT PK_DepotPosition PRIMARY KEY (DepotPositionId),
        CONSTRAINT FK_DepotPosition_Depotstand FOREIGN KEY (DepotstandId) REFERENCES dbo.Depotstand (DepotstandId)
    );
    CREATE INDEX IX_DepotPosition_Depotstand ON dbo.DepotPosition (DepotstandId);
END;

-------------------------------------------------------------------------------
-- Thema: zentrales Themen-Radar (nicht pro Mandant)
-------------------------------------------------------------------------------
IF OBJECT_ID(N'dbo.Thema', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Thema (
        ThemaId     UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_Thema_Id DEFAULT NEWID(),
        Kategorie   NVARCHAR(20)     NOT NULL,
        Titel       NVARCHAR(300)    NOT NULL,
        Kurzfassung NVARCHAR(2000)   NULL,
        GiltAb      DATE             NULL,
        Zeitraum    NVARCHAR(100)    NULL,
        BetrifftWen NVARCHAR(500)    NULL,
        QuelleLink  NVARCHAR(1000)   NULL,
        Status      NVARCHAR(20)     NOT NULL CONSTRAINT DF_Thema_Status DEFAULT N'aktuell',
        ErstelltAm  DATETIME2(0)     NOT NULL CONSTRAINT DF_Thema_ErstelltAm DEFAULT SYSUTCDATETIME(),
        CONSTRAINT PK_Thema PRIMARY KEY (ThemaId),
        CONSTRAINT CK_Thema_Kategorie CHECK (Kategorie IN (N'Markt', N'Vorsorge', N'Versicherung', N'Steuer')),
        CONSTRAINT CK_Thema_Status CHECK (Status IN (N'aktuell', N'archiv'))
    );
END;

COMMIT TRANSACTION;

-- Kontrolle nach dem Ausführen (sollte 10 Zeilen liefern):
-- SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' ORDER BY TABLE_NAME;
