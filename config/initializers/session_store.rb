# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: "_rekisync_session", expire_after: 1.month
Rails.application.config.session_store :redis_store, servers: "redis://127.0.0.1:6379/1", key: "lgewvnphasket", expire_after: 1.month
