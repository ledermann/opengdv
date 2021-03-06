# Der spartenspezifische Teil fuer Sparte KfZ
module GDV::Model::Sparte
    #
    # Kfz Hauptvertrag
    #
    class Kfz < Base
        #
        # Teilsparten von Kfz
        #
        class TeilSparte < Base
            def self.sparte
                n = self.name.split("::").last.upcase
                GDV::Model::Sparte.const_get("KFZ_#{n}")
            end

            def self.first
                { :sid => SPECIFIC, :sparte => sparte }
            end

            def self.inherited(subclass)
                subclass.grammar do
                    one    :specific, :sid => SPECIFIC,
                           :sparte => subclass.sparte
                    maybe  :addl,     :sid => SPEC_ADDL,
                           :sparte => subclass.sparte
                    star   :clauses,  :sid => GDV::Model::CLAUSES
                    star   :rebates,  :sid => GDV::Model::REBATES
                    objects :bausteine, GDV::Model::Sparte::Kfz::Baustein
                end
            end
        end

        class Baustein < TeilSparte; end

        class Haft < TeilSparte
            # Satzart: 0220.051, Teildatensatz 1
            property :kh_beginn,                                             :specific, 1, 8
            property :kh_ausschluss,                                         :specific, 1, 9
            property :kh_aenderungsdat,                                      :specific, 1,10
            property :kh_tarifgruppe,                                        :specific, 1,11
            property :kh_deckungsart,                                        :specific, 1,12
            property :kh_deckungssummen,                                     :specific, 1,13 
            property :kh_rgj,                                                :specific, 1,14 
            property :kh_sf_s_klasse,                                        :specific, 1,15
            property :kh_beitragssaetze,                                     :specific, 1,16
            property :kh_beitrag_in_we,                                      :specific, 1,17
            property :kh_zuschlaege_in_proz,                                 :specific, 1,18
            property :kh_abschlaege_in_proz,                                 :specific, 1,19
            property :kh_zuschlaege_in_we,                                   :specific, 1,20
            property :kh_abschlaege_in_we,                                   :specific, 1,21
            property :flottenrabatt_in_proz,                                 :specific, 1,22
            property :gueltige_akb,                                          :specific, 1,23
            property :provision,                                             :specific, 1,24
            property :kh_schaeden_aus_rueckstufung,                          :specific, 1,25
            property :kennzeichen_abweichende_provision,                     :specific, 1,26
            property :tarifbeitrag100_proz_kraftfahrt_haftpflicht_in_we,     :specific, 1,27
            property :schutzbrief_verkehrsservice,                           :specific, 1,28
            property :referenz_nr,                                           :specific, 1,29
            property :frei_vereinbarte_selbstbeteiligung_in_we_kh,           :specific, 1,30
            property :tyklasse_kh,                                           :specific, 1,31
            property :tarif,                                                 :specific, 1,32
            property :lfd_nr,                                                :specific, 1,33
            property :personen_nr_lfd_nr,                                    :specific, 1,34
            
            # Satzart: 0220.051, Teildatensatz 2
            property :produktkennung,                                        :specific, 2, 8
            property :versicherte_gefahren,                                  :specific, 2, 9
            property :selbstbeteiligung_in_proz,                             :specific, 2,10
            property :selbstbeteiligung_in_we_mind,                          :specific, 2,11
            property :selbstbeteiligung_in_we_max,                           :specific, 2,12
            property :geltungsbereich,                                       :specific, 2,13
            property :geltungsbereicheinschraenkung,                         :specific, 2,14

            # Satzart: 0221.051
            property :eur_kh_deckungssummen_in_we,                           :addl, 1, 8
            property :eur_kh_beitrag_in_we,                                  :addl, 1, 9
            property :eur_kh_zuschlaege_in_we,                               :addl, 1,10
            property :eur_kh_abschlaege_in_we,                               :addl, 1,11
            property :eur_tarifbeitrag100_proz_kraftfahrt_haftpflicht_in_we, :addl, 1,12
            property :eur_frei_vereinbarte_selbstbeteiligung_in_we_kh,       :addl, 1,13
            
            # Use value from 'addl', if exists. Otherweise, use from 'specific'
            def kh_beitrag_in_we;                                  addl ? addl[1][ 9] : specific[1][17] end
            def kh_zuschlaege_in_we;                               addl ? addl[1][10] : specific[1][20] end
            def kh_abschlaege_in_we;                               addl ? addl[1][11] : specific[1][21] end
            def tarifbeitrag100_proz_kraftfahrt_haftpflicht_in_we; addl ? addl[1][12] : specific[1][27] end
            def frei_vereinbarte_selbstbeteiligung_in_we_kh;       addl ? addl[1][13] : specific[1][30] end
            
            # 3-in-1, split them
            def deckungssumme_personen
              addl ? eur_kh_deckungssummen_in_we_raw[ 0..13].to_i / 100 : kh_deckungssummen_raw[ 0.. 8].to_i
            end
            def deckungssumme_sach
              result = addl ? eur_kh_deckungssummen_in_we_raw[14..27].to_i / 100 : kh_deckungssummen_raw[ 9..17].to_i
              result.zero? ? deckungssumme_personen : result
            end
            def deckungssumme_vermoegen
              result = addl ? eur_kh_deckungssummen_in_we_raw[28..41].to_i / 100 : kh_deckungssummen_raw[18..26].to_i
              result.zero? ? deckungssumme_sach : result
            end
        end

        class Voll < TeilSparte
            property :begin_on,        :specific, 1,  8
            property :excluded_on,     :specific, 1,  9
            property :changed_on,      :specific, 1, 10
            property :regionalklasse,  :specific, 1, 11
            property :deckungsart,     :specific, 1, 12
            property :rabattgrundjahr, :specific, 1, 13
            property :sfs,             :specific, 1, 14
            property :beitragssatz,    :specific, 1, 15
            property :beitrag,         :specific, 1, 16
            property :claims_prev_year, :specific, 1, 24
            property :typkl,           :specific, 1, 25
            property :free_deductible,      :specific, 1, 26
            property :free_deductible_tk,   :specific, 1, 30
            property :gap_deckung,     :specific, 1, 36
        end

        class Teil < TeilSparte
            # Satzart: 0220.053, Teildatensatz 1
            property :kft_beginn,                                              :specific, 1, 8
            property :kft_ausschluss,                                          :specific, 1, 9
            property :kft_aenderungsdat,                                       :specific, 1,10
            property :kft_tarifgruppe,                                         :specific, 1,11
            property :kft_deckungsart,                                         :specific, 1,12
            property :kft_beitrag_in_we,                                       :specific, 1,13
            property :kft_zuschlaege_in_proz,                                  :specific, 1,14
            property :kft_abschlaege_in_proz,                                  :specific, 1,15
            property :kft_zuschlaege_in_we,                                    :specific, 1,16
            property :kft_abschlaege_in_we,                                    :specific, 1,17
            property :flottenrabatt_in_proz,                                   :specific, 1,18
            property :gueltige_akb,                                            :specific, 1,19
            property :provision,                                               :specific, 1,20
            property :typklasse_kft,                                           :specific, 1,21
            property :frei_vereinbarte_selbstbeteiligung_in_we_teilkasko,      :specific, 1,22
            property :kennzeichen_abweichende_provision,                       :specific, 1,23
            property :tarifbeitrag100_proz_kraftfahrt_fahrzeugteil_in_we,      :specific, 1,24
            property :referenz_nr,                                             :specific, 1,25
            property :tarif,                                                   :specific, 1,26
            property :lfd_nr,                                                  :specific, 1,27
            property :personen_nr_lfd_nr,                                      :specific, 1,28
            property :schutzbrief_verkehrsservice,                             :specific, 1,29
            property :gap_deckung,                                             :specific, 1,30

            # Satzart: 0220.053, Teildatensatz 2
            property :produktkennung,                                          :specific, 2, 8
            property :versicherte_gefahren,                                    :specific, 2, 9
            property :selbstbeteiligung_in_proz,                               :specific, 2,10
            property :selbstbeteiligung_in_we_mind,                            :specific, 2,11
            property :selbstbeteiligung_in_we_max,                             :specific, 2,12
            property :geltungsbereich,                                         :specific, 2,13
            property :geltungsbereicheinschraenkung,                           :specific, 2,14

            # Satzart: 0221.053
            property :eur_kft_beitrag_in_we,                                   :addl, 1, 8
            property :eur_kft_zuschlaege_in_we,                                :addl, 1, 9
            property :eur_kft_abschlaege_in_we,                                :addl, 1,10
            property :eur_frei_vereinbarte_selbstbeteiligung_in_we_teilkasko,  :addl, 1,11
            property :eur_tarifbeitrag100_proz_kraftfahrt_fahrzeugteil_in_we,  :addl, 1,12
            property :eur_referenz_nr,                                         :addl, 1,13
            property :eur_lfd_nr,                                              :addl, 1,14
            property :eur_personen_nr_lfd_nr,                                  :addl, 1,15
          
            # Use value from 'addl', if exists. Otherweise, use from 'specific'
            def kft_beitrag_in_we;                                  addl ? addl[1][ 8] : specific[1][13] end
            def kft_zuschlaege_in_we;                               addl ? addl[1][ 9] : specific[1][16] end
            def kft_abschlaege_in_we;                               addl ? addl[1][10] : specific[1][17] end
            def frei_vereinbarte_selbstbeteiligung_in_we_teilkasko; addl ? addl[1][11] : specific[1][22] end
            def tarifbeitrag100_proz_kraftfahrt_fahrzeugteil_in_we; addl ? addl[1][12] : specific[1][24] end
        end

        class Unfall < TeilSparte
            property :deckung1, :specific, 1, 11
            property :invaliditaet, :addl, 1, 9
            property :beitrag, :specific, 1, 25
        end

        class Gepaeck < TeilSparte; end

        #
        # Main Kfz class
        #

        grammar do
            one    :details, :sid => DETAILS
            maybe  :addl, :sid => ADDL
            star   :clauses, :sid => GDV::Model::CLAUSES
            star   :rebates, :sid => GDV::Model::REBATES

            object :haft, Haft
            object :voll, Voll
            object :teil, Teil
            object :unfall, Unfall
            objects :bausteine, Baustein
            object :gepaeck, Gepaeck

            error(:unexpected) { |parser| parser.satz?(SPECIFIC) }
        end

        first :sid => DETAILS, :sparte => KFZ

        # Satzart: 0210.050, Teildatensatz 1
        property :wkz,                                                :details, 1,  8
        property :staerke,                                            :details, 1,  9
        property :herstellername,                                     :details, 1, 10
        property :modellname,                                         :details, 1, 11
        property :hersteller_schluessel_nr,                           :details, 1, 12 
        property :typschluessel_nr,                                   :details, 1, 13
        property :fahrzeugidentifizierungs_nr,                        :details, 1, 14
        property :amtliches_kennzeichen,                              :details, 1, 15
        property :erstzulassung,                                      :details, 1, 16
        property :neupreis_in_we,                                     :details, 1, 17
        property :mehrwert_in_we,                                     :details, 1, 18
        property :kennung_abs_rabatt,                                 :details, 1, 19
        property :flottenkennzeichen,                                 :details, 1, 20
        property :waehrung,                                           :details, 1, 21
        property :gesbeitrag_in_we,                                   :details, 1, 22
        property :sicherungsschein,                                   :details, 1, 23
        property :sonderbedingungen_klauseln,                         :details, 1, 24
        property :sicherungseinrichtung,                              :details, 1, 25
        property :klartext_sicherungseinrichtung,                     :details, 1, 26
        property :schluessel_sicherungseinrichtung,                   :details, 1, 27
        property :baustein_gesbeitrag1_in_we,                         :details, 1, 28
        property :baustein_gesbeitrag2_in_we,                         :details, 1, 29
        property :referenz_nr,                                        :details, 1, 30
        property :lfd_nr,                                             :details, 1, 31
        property :personen_kunden_nr_versicherers,                    :details, 1, 32
        property :saisonkennzeichen,                                  :details, 1, 33

        # Satzart: 0210.050, Teildatensatz 2
        property :produktform,                                        :details, 2,  8
        property :produktform_gueltig_ab,                             :details, 2,  9
        property :fahrzeugart,                                        :details, 2, 10
        property :art_amtlichen_kennzeichens,                         :details, 2, 11
        property :land_amtl_kennzeichens,                             :details, 2, 12
        property :baujahr,                                            :details, 2, 13
        property :erste_zulassung_auf_den_vn,                         :details, 2, 14
        property :art_zulassung_beim_vorbesitzer,                     :details, 2, 15
        property :anz_vorbesitzer,                                    :details, 2, 16
        property :kaufpreis,                                          :details, 2, 17
        property :mehrwertgrund,                                      :details, 2, 18
        property :lfd_personen_nr_sicherungsglaeubigers,              :details, 2, 19
        property :jaehrliche_fahrleistung,                            :details, 2, 20
        property :garage,                                             :details, 2, 21
        property :nutzungsart,                                        :details, 2, 22
        property :eigentumsverhaeltnis_fahrzeug,                      :details, 2, 23
        property :wohneigentum,                                       :details, 2, 24
        property :produktname,                                        :details, 2, 25
        property :kreisgemeindeschluessel,                            :details, 2, 26
        property :kreisgemeindeschluessel_zusatzinformation,          :details, 2, 27
        property :beginn_versicherungsschutz,                         :details, 2, 28
        property :endedatum_bei_roten_kennzeichen,                    :details, 2, 29
        property :gueltigkeitsdauer_in_tagen_bei_kurzzeitkennzeichen, :details, 2, 30
        property :e_vb_nummer,                                        :details, 2, 31
        property :aufbauart,                                          :details, 2, 32
        property :gefahrgut,                                          :details, 2, 33
        property :gesamtmasse,                                        :details, 2, 34
        property :staerkeeinheit,                                     :details, 2, 35
        
        # Satzart: 0211.050
        property :eur_neupreis_in_we,                                 :addl,    1,  8
        property :eur_mehrwert_in_we,                                 :addl,    1,  9
        property :eur_referenz_nr,                                    :addl,    1, 10
        property :eur_lfd_nr,                                         :addl,    1, 11
        property :eur_personen_kunden_nr_versicherers,                :addl,    1, 12
        
        # Use value from 'addl', if exists. Otherweise, use from 'details'
        def neupreis_in_we; addl ? addl[1][8] : details[1][17]; end
        def mehrwert_in_we; addl ? addl[1][9] : details[1][18]; end
    end
end
