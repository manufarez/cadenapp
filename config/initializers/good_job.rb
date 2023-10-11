# show in logs
# STDOUT.sync = true
# $stdout.sync = true

Rails.application.configure do
  config.good_job.enable_cron = true
  config.good_job.cron = {
    every_day_at_8: {
      cron: '0 8 * * *',
      class: "PaymentReminderJob",
      set: { priority: -10 }
    }
  }
end
