let g:rails_projections = {
  \  "app/services/*_service.rb": {
  \    "command":   "service",
  \    "alertnate": "spec/services/%i_spec.rb",
  \    "related":   "db/schema.rb#%s",
  \    "test":      "spec/services/%i_spec.rb",
  \    "template":  "class %SService\nend",
  \    "keywords":  "service sequence"
  \  },
  \  "app/serializers/*_serializer.rb": {
  \    "command":   "serializer",
  \    "alternate": "app/models/%i.rb",
  \    "related":   "db/schema.rb#%s",
  \    "test":      "spec/serializers/%i_spec.rb",
  \    "template":  "class %SSerializer < ActiveModel::Serializer\nend",
  \    "keywords":  "serializer sequence"
  \  },
  \  "app/queries/*_query.rb": {
  \    "command":   "query",
  \    "alertnate": "spec/queries/%i_spec.rb",
  \    "related":   "db/schema.rb#%s",
  \    "test":      "spec/queries/%i_spec.rb",
  \    "template":  "class %SQuery\nend",
  \    "keywords":  "query sequence"
  \  },
  \  "spec/factories/*.rb": {
  \    "command":   "factory",
  \    "affinity":  "collection",
  \    "alternate": "app/models/%i.rb",
  \    "related":   "db/schema.rb#%s",
  \    "test":      "spec/models/%i_spec.rb",
  \    "template":  "FactoryGirl.define do\n  factory :%i do\n  end\nend",
  \    "keywords":  "factory sequence"
  \  },
  \  "spec/factories.rb": {"command": "factory"},
  \  "app/presenters/*_presenter.rb": {
  \    "command":   "presenter",
  \    "alternate": "app/models/%i.rb",
  \    "related":   "db/schema.rb#%s",
  \    "test":      "spec/presenters/%i_spec.rb",
  \    "template":  "class %SPresenter < BasePresenter\n  presents :%i\nend",
  \    "keywords":  "presenter sequence"
  \  },
  \  "app/presenters/application_presenter.rb": {"command": "presenter"}}
