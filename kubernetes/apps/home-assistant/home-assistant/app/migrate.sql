LOAD database
FROM 'ha.db.sqlite'
INTO pgsql://home-assistant:<password>@<host>/home-assistant
WITH
  include no drop,
  no truncate,
create no tables,
    create no indexes,
    reset no sequences,
    batch concurrency = 1

BEFORE LOAD DO
    $$ TRUNCATE
        event_data,
        event_types,
        events,
        migration_changes,
        recorder_runs,
        schema_changes,
        state_attributes,
        states,
        states_meta,
        statistics,
        statistics_meta,
        statistics_runs,
        statistics_short_term;
    $$
AFTER LOAD DO
    $$ SELECT setval('event_data_data_id_seq',MAX(data_id)) FROM event_data;$$,
    $$ SELECT setval('event_types_event_type_id_seq',MAX(event_type_id)) FROM event_types;$$,
    $$ SELECT setval('events_event_id_seq',MAX(event_id)) FROM events;$$,
    $$ SELECT setval('recorder_runs_run_id_seq',MAX(run_id)) FROM recorder_runs;$$,
    $$ SELECT setval('schema_changes_change_id_seq',MAX(change_id)) FROM schema_changes;$$,
    $$ SELECT setval('state_attributes_attributes_id_seq',MAX(attributes_id)) FROM state_attributes;$$,
    $$ SELECT setval('states_state_id_seq',MAX(state_id)) FROM states;$$,
    $$ SELECT setval('states_meta_metadata_id_seq',MAX(metadata_id)) FROM states_meta;$$,
    $$ SELECT setval('statistics_id_seq',MAX(id)) FROM statistics;$$,
    $$ SELECT setval('statistics_meta_id_seq',MAX(id)) FROM statistics_meta;$$,
    $$ SELECT setval('statistics_runs_run_id_seq',MAX(run_id)) FROM statistics_runs;$$,
    $$ SELECT setval('statistics_short_term_id_seq',MAX(id)) FROM statistics_short_term;$$
;
