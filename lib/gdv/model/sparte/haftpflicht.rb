# Der spartenspezifische Teil fuer Sparte 040 Haftpflicht
module GDV::Model::Sparte
  class HaftpflichtRisk < Base
      grammar do
          one     :data,    :sid => SPECIFIC,  :sparte => HAFTPFLICHT
          maybe   :addl,    :sid => SPEC_ADDL, :sparte => HAFTPFLICHT
          star    :clauses, :sid => GDV::Model::CLAUSES
          star    :rebates, :sid => GDV::Model::REBATES
      end
      
      property    :wagnisart,            :data, 1,  8
      
      property    :wagnistext,           :data, 2, 11
      property    :wagnisbeschreibung,   :data, 2, 12
      
      property    :deckungssumme1_in_we, :addl, 1, 11
  end
  
  class Haftpflicht < Base
      grammar do
          one     :details,  :sid => DETAILS, :sparte => HAFTPFLICHT
          maybe   :addl,     :sid => ADDL, :sparte => HAFTPFLICHT
          star    :clauses,  :sid => GDV::Model::CLAUSES
          star    :rebates,  :sid => GDV::Model::REBATES
          objects :risks, HaftpflichtRisk
      end

      property    :summenart1,                   :details, 1, 12
      property    :waehrungsschluessel1,         :details, 1, 13
      property    :deckungssumme1_in_tausend_we, :details, 1, 14
      property    :gesbeitrag_in_we,             :details, 1, 31
      
      property    :deckungssumme1_in_we,         :addl,    1,  8
  end
end