-- Migração: sincronização com Google Calendar
-- Rode UMA vez no Postgres, depois do schema.sql

-- Qual calendário do Google pertence a cada profissional.
-- 'primary' = seu calendário principal (suficiente para o portfólio).
ALTER TABLE profissionais ADD COLUMN IF NOT EXISTS google_calendar_id TEXT DEFAULT 'primary';

-- ID do evento criado no Google Calendar, usado para cancelar/editar depois.
ALTER TABLE agendamentos ADD COLUMN IF NOT EXISTS google_event_id TEXT;

-- Opcional: um calendário por profissional. O ID aparece em
-- Google Calendar > Configurações do calendário > "Integrar agenda" > ID da agenda.
-- UPDATE profissionais SET google_calendar_id = 'xxxxx@group.calendar.google.com' WHERE nome = 'Dra. Ana';

-- Impede dois agendamentos ativos no mesmo horário para o mesmo profissional,
-- mesmo que o agente falhe ou repita uma chamada. Rode depois de limpar duplicatas:
-- DELETE FROM agendamentos;
CREATE UNIQUE INDEX IF NOT EXISTS uq_agendamento_horario
ON agendamentos (profissional_id, data_hora)
WHERE status <> 'cancelado';
