This is a Rails app that does things

Users can't register, they can only be provisioned by admins.
To provision, go to rails console, and issue User.create(:email=>"their_email@place.ya"). They'll be sent a confirmation email (or in dev mode, it'll be printed in logs) 