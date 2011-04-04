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
            property :regionalklasse, :specific, 1, 11
            property :sfs,            :specific,  1, 15

            def beitrag
                return addl[1][9] if addl
                specific[1][17]
            end
        end

        class Voll < TeilSparte
            property :beitrag,        :specific, 1, 16
        end

        class Teil < TeilSparte
            property :typkl, :specific, 1, 21
            property :beitrag, :addl, 1, 8
            def beitrag
                return addl[1][8] if addl
                specific[1][13]
            end
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
        # property :neupreis_in_we,                                     :addl,    1,  8
        # property :mehrwert_in_we,                                     :addl,    1,  9
        # property :referenz_nr,                                        :addl,    1, 10
        # property :lfd_nr,                                             :addl,    1, 11
        # property :personen_kunden_nr_versicherers,                    :addl,    1, 12
    end
end
