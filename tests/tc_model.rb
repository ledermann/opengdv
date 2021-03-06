# encoding: UTF-8
require 'test_helper'

class TestModel < Test::Unit::TestCase
    def test_transmission
        transmission "muster_bestand.gdv"

        assert_equal 1, @transmission.packages.size
        assert_equal data_file("muster_bestand.gdv"), @package.filename
        assert_equal 1, @transmission.packages.size

        assert_equal("9999", @package.vunr)
        d = Date.civil(2004, 7, 22)
        assert_equal(d, @package.created_from)
        assert_equal(d, @package.created_until)

        assert_equal(14, @package.contracts.size)
        c = @package.contracts.first
        p = c.vn
        assert_equal("2", p.anrede_raw)
        assert_equal("Frau", p.anrede)
        assert_equal("", p.geburtsort)

        assert_equal("Frau", p.address.anredeschluessel)
        assert_equal("Martina", p.address.name3)
        g = c.general
        assert_not_nil g
        assert_equal("EUR", g[1].raw(21))
        assert_equal("B4LTTT", g[1][25])
    end

    def test_multiple_partner
        transmission "multiple_addresses.gdv"

        assert_equal 1, @package.contracts.size
        contract = @package.contracts[0]
        vn = contract.vn
        assert_equal "Kunde", vn.address.name1
        assert_equal "Versicherungsnehmer", vn.address.adress_kennzeichen
        assert_equal "01", vn.address[1].raw(:adress_kennzeichen)

        assert_equal 1, contract.partner.size
        partner = contract.partner[0]
        assert_equal "Vermittler", partner.address.name1
        assert_equal "Vermittler", partner.address.adress_kennzeichen
        assert_equal "14", partner.address[1].raw(:adress_kennzeichen)
    end

    def test_kfz
        transmission "muster_bestand.gdv"

        contracts = contracts_for(GDV::Model::Sparte::KFZ)
        assert_equal(4, contracts.size)

        c = contracts.first
        assert_not_nil c

        assert_equal("Gillensvier", c.vn.nachname)
        assert_equal("Herbert", c.vn.vorname)
        assert_equal("W45KKK", c.vn.kdnr_vu)

        assert_equal("59999999990", c.vsnr)
        assert_equal(Date.civil(2004, 7, 1), c.begin_on)
        assert_equal(Date.civil(2005,1,1), c.end_on)
        assert_equal(Date.civil(2005,1,1), c.renewal)

        kfz = c.sparte
        assert_equal("VW", kfz.herstellername)
        assert_equal('1J (GOLF IV 1.9 TDI SYNCR', kfz.modellname)
        assert_equal(0, kfz.neupreis_in_we)

        assert_not_nil kfz.haft
        assert_equal("R8", kfz.haft.kh_tarifgruppe)
        assert_equal("1/2", kfz.haft.kh_sf_s_klasse)
        assert_equal(866.87, kfz.haft.kh_beitrag_in_we)

        assert_not_nil kfz.teil
        assert_equal("R8", kfz.teil.kft_tarifgruppe)
        assert_equal("22", kfz.teil.typklasse_kft)
        assert_equal(173.58, kfz.teil.kft_beitrag_in_we)

        assert_not_nil kfz.unfall
        assert_equal("1", kfz.unfall.deckung1_raw)
        assert_equal(30000.0, kfz.unfall.invaliditaet)
    end
    
    def test_haftpflicht
      transmission 'muster_bestand.gdv'

      contracts = contracts_for(GDV::Model::Sparte::HAFTPFLICHT)
      assert_equal(6, contracts.size)

      c = contracts.first
      assert_not_nil c

      assert_equal('Fresy', c.vn.nachname)
      assert_equal('Wilhelm', c.vn.vorname)
      assert_equal('W45BBB', c.vn.kdnr_vu)

      assert_equal('59999999995', c.vsnr)
      assert_equal('2004-08-04', c.begin_on.to_s)
      assert_equal('2008-07-01', c.end_on.to_s)
      assert_equal('2005-07-01', c.renewal.to_s)

      grunddaten = c.sparte
      assert_not_nil grunddaten
      assert_equal(112.50, grunddaten.gesbeitrag_in_we)
      
      wagnis = c.sparte.risks.first
      assert_not_nil wagnis
      assert_equal('9001  ', wagnis.wagnisart_raw)
    end

    def test_multi_package
        # Generated by concatenating
        # multiple_addresses.gdv muster_bestand.gdv multiple_addresses.gdv
        transmission "multi_package.gdv"

        assert_equal 3, @transmission.packages.size
        assert_equal 16, @transmission.contracts_count
        assert_equal 15, @transmission.unique_contracts_count
    end

    def test_yaml_contract
        transmission "muster_bestand.gdv"

        contracts = contracts_for(GDV::Model::Sparte::KFZ)
        assert_equal(4, contracts.size)

        c = YAML::load(contracts.first.to_yaml)

        assert_equal("Gillensvier", c.vn.nachname)
        assert_equal("Herbert", c.vn.vorname)
        assert_equal("W45KKK", c.vn.kdnr_vu)

        assert_equal("59999999990", c.vsnr)
        assert_equal(Date.civil(2004, 7, 1), c.begin_on)
        assert_equal(Date.civil(2005,1,1), c.end_on)
        assert_equal(Date.civil(2005,1,1), c.renewal)

        kfz = c.sparte
        assert_equal("VW", kfz.herstellername)
        assert_equal('1J (GOLF IV 1.9 TDI SYNCR', kfz.modellname)
        assert_equal(0, kfz.neupreis_in_we)

        assert_not_nil kfz.haft
        assert_equal("R8", kfz.haft.kh_tarifgruppe)
        assert_equal("1/2", kfz.haft.kh_sf_s_klasse)
        assert_equal(866.87, kfz.haft.kh_beitrag_in_we)
        
        assert_equal(50000000.00, kfz.haft.deckungssumme_personen)
        assert_equal(50000000.00, kfz.haft.deckungssumme_sach)
        assert_equal(50000000.00, kfz.haft.deckungssumme_vermoegen)

        assert_not_nil kfz.teil
        assert_equal("R8", kfz.teil.kft_tarifgruppe)
        assert_equal("22", kfz.teil.typklasse_kft)
        assert_equal(173.58, kfz.teil.kft_beitrag_in_we)
        
        assert_not_nil kfz.unfall
        assert_equal("1", kfz.unfall.deckung1_raw)
        assert_equal(30000.0, kfz.unfall.invaliditaet)
    end

    def test_cset
        transmission "muster_bestand.gdv"
        vn = @transmission.packages[0].contracts[0].vn
        assert_equal "Kitzelpf\xc3\xbctze", vn.nachname
    end

    def test_garbage
        assert_raises GDV::Format::MatchError do
            transmission "garbage.gdv"
        end
        assert_raises GDV::Format::MatchError do
            transmission "missing_nachsatz.gdv"
        end
    end

    def test_kranken
        transmission "kranken.gdv"
        contract = @package.contracts.first
        assert_equal "VS12345", contract.vsnr
        assert_equal 1, contract.sparte.vps.size
        vp = contract.sparte.vps.first
        assert_equal "Mayer", vp.nachname
        assert_equal 1, vp.rates.size
        assert_equal "004T", vp.rates.first.benefit_begin
    end

    def test_unfall
        transmission "unfall.gdv"
        contract = @package.contracts.first
        assert_equal "1122334455", contract.vsnr

        assert_equal "U88:01", contract.sparte.tarif
        assert_equal 4, contract.sparte.vps.size
        vp = contract.sparte.vps.first
        assert_equal "Moele", vp.nachname
        assert_equal "Norbert", vp.vorname
    end

    def test_undefined_field
        contract = GDV::Model::Contract.new
        assert_raises(ArgumentError) { contract.lob }
        assert_raises(ArgumentError) { contract.lob_raw }
        assert_raises(ArgumentError) { contract.lob_orig }
        assert_nil contract.lob(:default => nil)
        assert_equal "None", contract.lob(:default => "None")
    end

    def contracts_for(sp)
        @package.contracts.select { |c| c.sparte?(sp) }
    end

    def transmission(filename)
        @transmission = GDV::Model::Transmission.new(data_file(filename))
        @package = @transmission.packages.first
    end
end
