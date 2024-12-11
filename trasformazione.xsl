<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <html lang="it">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>La Rassegna Settimanale - Edizione Digitale</title>
                <link rel="stylesheet" type="text/css" href="rassegna-style.css"/>
                <script src="rassegna-script.js" defer="defer"></script>
            </head>
            <body>
                <header>
                    <h1>
                        <xsl:value-of select="//tei:title"/>
                    </h1>
                    <p>Codifica TEI realizzata da: <xsl:value-of select="//tei:name[@xml:id='ele_perk']"/>
                    </p>
                </header>
                <main>
                    <section class="metadata">
                        <div class="section">
                            <h2>Note</h2>
                            <xsl:for-each select="//tei:notesStmt/tei:note">
                                <p>
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </div>

                        <div class="section">
                            <h2>Fonte</h2>
                            <div class="subsection">
                                <p>
                                    <span class="label">Lingua:</span>
                                    <xsl:value-of select="//tei:monogr/tei:textLang"/>
                                </p>
                                <p>
                                    <span class="label">Fondata da:</span>
                                    <xsl:value-of select="//tei:monogr/tei:respStmt/tei:name[1]"/>
,                                    <xsl:value-of select="//tei:monogr/tei:respStmt/tei:name[2]"/>
                                </p>
                                <p>
                                    <span class="label">Luogo di pubblicazione:</span>
                                    <xsl:value-of select="//tei:monogr/tei:imprint/tei:pubPlace"/>
                                </p>
                                <p>
                                    <span class="label">Editore:</span>
                                    <xsl:value-of select="//tei:monogr/tei:imprint/tei:publisher"/>
                                </p>
                                <p>
                                    <span class="label">Data:</span>
                                    <xsl:value-of select="//tei:monogr/tei:imprint/tei:date"/>
                                </p>
                                <p>
                                    <span class="label">Volume:</span>
                                    <xsl:value-of select="//tei:monogr/tei:biblScope[@unit='volume']"/>
                                </p>
                                <p>
                                    <span class="label">Fascicolo:</span>
                                    <xsl:value-of select="//tei:monogr/tei:biblScope[@unit='file']"/>
                                </p>
                                <p>
                                    <span class="label">Pagine:</span>
                                    <xsl:value-of select="//tei:monogr/tei:biblScope[@unit='page']"/>
                                </p>
                            </div>
                        </div>

                        <div class="section">
                            <h2>Codifica</h2>
                            <p>
                                <xsl:value-of select="//tei:encodingDesc/tei:projectDesc/tei:p"/>
                            </p>
                        </div>
                        <div id="phenomenon-buttons">
                            <button class="phenomenon-btn" data-phenomenon="person">Persone</button>
                            <button class="phenomenon-btn" data-phenomenon="place">Luoghi</button>
                            <button class="phenomenon-btn" data-phenomenon="role">Ruoli</button>
                            <button class="phenomenon-btn" data-phenomenon="organization">Organizzazioni</button>
                        </div>
                    </section>
                    <div class="columns">
                        <div class="column facsimile-column">
                            <h2>Facsimile</h2>
                            <xsl:apply-templates select="//tei:facsimile/tei:surface[not(tei:graphic/@url = preceding::tei:surface/tei:graphic/@url)]"/>
                        </div>
                        <div class="column transcription-column">
                            <h2>Trascrizione</h2>
                            <xsl:apply-templates select="//tei:div[@type='article']"/>
                        </div>
                    </div>
                </main>
                <footer>
                    <p>©                        <xsl:value-of select="//tei:publicationStmt/tei:date"/>
, 
                        <xsl:value-of select="//tei:publisher"/>
                    </p>
                </footer>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:surface">
        <div class="facsimile">
            <img src="img/{tei:graphic/@url}" alt="Facsimile delle pagina {@n}" usemap="#facsimile-map-{generate-id()}"/>
            <map name="facsimile-map-{generate-id()}">
                <xsl:apply-templates select="tei:zone"/>
                <xsl:apply-templates select="following::tei:surface[tei:graphic/@url = current()/tei:graphic/@url]/tei:zone"/>
            </map>
            <p>Pagina: 
                <xsl:value-of select="@n"/>
            </p>
        </div>
    </xsl:template>

    <xsl:template match="tei:zone">
        <area shape="rect" data-coords="{@ulx},{@uly},{@lrx},{@lry}" coords="{@ulx},{@uly},{@lrx},{@lry}" href="#{@xml:id}" alt="Zona {position()}"/>
    </xsl:template>

    <xsl:template match="tei:div[@type='article']">
        <article>
            <h3>
                <xsl:value-of select="tei:head"/>
            </h3>
            <div class="article-content">
                <xsl:apply-templates select="tei:ab"/>
            </div>
        </article>
    </xsl:template>

    <xsl:template match="tei:ab">
        <div class="column">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:cb">
        <xsl:text disable-output-escaping="yes">&lt;/div&gt;&lt;div class="column"&gt;</xsl:text>
    </xsl:template>


    <xsl:template match="tei:lb[not(@break)]">
        <br/>

        <span id="{@facs}" class="highlight-target">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:persName">
        <span class="person">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:orgName">
        <span class="organization">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:roleName">
        <span class="role">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:placeName">
        <span class="place">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
</xsl:stylesheet>