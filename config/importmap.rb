# config/importmap.rb
pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3
pin_all_from "app/javascript/controllers", under: "controllers"

pin "@popperjs/core", to: "popper.js", preload: true # Ou 'popper.min.js', dependendo de como você instalou
pin "bootstrap", to: "bootstrap.min.js", preload: true
