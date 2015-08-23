# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( common/application.min.css )
Rails.application.config.assets.precompile += %w( index/bootstrap.min.css )
Rails.application.config.assets.precompile += %w( index/font-awesome.min.css )
Rails.application.config.assets.precompile += %w( index/animate.min.css )
Rails.application.config.assets.precompile += %w( index/creative.css )
Rails.application.config.assets.precompile += %w( index/jquery.easing.min.js )
Rails.application.config.assets.precompile += %w( index/jquery.fittext.js )
Rails.application.config.assets.precompile += %w( index/creative.js )
Rails.application.config.assets.precompile += %w( index/wow.min.js )
Rails.application.config.assets.precompile += %w( index/bootstrap.min.js )
Rails.application.config.assets.precompile += %w( index/jquery.js )
Rails.application.config.assets.precompile += %w( custom/custom.css )
