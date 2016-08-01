{application,cb_tutorial,
    [{description,"My Awesome Web Framework"},
     {vsn,"0.0.1"},
     {modules,
         [cb_tutorial_outgoing_mail_controller,
          cb_tutorial_incoming_mail_controller,
          cb_tutorial_greeting_controller,cb_tutorial_custom_filters,
          cb_tutorial_custom_tags,cb_tutorial_view_lib_tags]},
     {registered,[]},
     {applications,[kernel,stdlib,crypto]},
     {env,
         [{test_modules,[]},
          {lib_modules,[]},
          {websocket_modules,[]},
          {mail_modules,
              [cb_tutorial_outgoing_mail_controller,
               cb_tutorial_incoming_mail_controller]},
          {controller_modules,[cb_tutorial_greeting_controller]},
          {model_modules,[]},
          {view_lib_helper_modules,
              [cb_tutorial_custom_filters,cb_tutorial_custom_tags]},
          {view_lib_tags_modules,[cb_tutorial_view_lib_tags]},
          {view_modules,[]}]}]}.