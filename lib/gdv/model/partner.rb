# The partner portion of a contract
module GDV::Model
    class Partner < Base
        grammar do
            one  :address,    :sid => ADDRESS_TEIL
            star :signatures, :sid => SIGNATURES
            star :clauses,    :sid => CLAUSES
            star :rebates,    :sid => REBATES
        end
        first :sid => ADDRESS_TEIL

        property :anrede,   :address, 1, 8
        property :nachname, :address, 1, 9
        property :vorname,  :address, 1, 11
        property :land,     :address, 1, 13
        property :plz,      :address, 1, 14
        property :ort,      :address, 1, 15
        property :strasse,  :address, 1, 16
        property :postfach, :address, 1, 17
        property :birthdate,:address, 1, 18
        property :geschlecht, :address, 1, 25

        property :kdnr_vu,  :address, 2, 8
        property :kontonummer_1,    :address, 2, 11
        property :blz_1,            :address, 2, 12
        property :kontoinhaber_1,   :address, 2, 13
        property :komm_typ_1,       :address, 2, 14
        property :komm_nummer_1,    :address, 2, 15
        property :komm_typ_2,       :address, 2, 16
        property :komm_nummer_2,    :address, 2, 17
        property :komm_typ_3,       :address, 2, 18
        property :komm_nummer_3,    :address, 2, 19
        property :komm_typ_4,       :address, 2, 20
        property :komm_nummer_4,    :address, 2, 21
        
        property :komm_typ_5,       :address, 3, 8
        property :komm_nummer_5,    :address, 3, 9
        property :komm_typ_6,       :address, 3, 10
        property :komm_nummer_6,    :address, 3, 11
        property :komm_typ_7,       :address, 3, 12
        property :komm_nummer_7,    :address, 3, 13

        property :kreditinstitut_1, :address, 4, 9
        property :kontonummer_2,    :address, 4, 12
        property :blz_2,            :address, 4, 13
        property :kontoinhaber_2,   :address, 4, 14
        property :kreditinstitut_2, :address, 4, 15
        property :bic_1,            :address, 4, 16
        property :bic_2,            :address, 4, 17
        property :iban_1,           :address, 4, 18

        property :iban_2,        :address, 5, 8
        property :geburtsort, :address, 5, 9
    end
end
