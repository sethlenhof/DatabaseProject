- [x] 1. Create a login page
  - [x] add login button functionality
- [x] 2. Create a sign up page
  - [x] add sign up button functionality
- [x] 3. Create main landing page: shows all events
- [ ] 4. Research showing data from events.ucf
- [ ] 5. Add additional info for different users
  - [] a. Super admin: create profile for university
    - Name, location, num students, pictures, etc
  - [ ] b. Admin: create events, owns an RSO with a university
  - [ ] c. Student: can join RSOs, attend events
- [ ] 6. Event page: shows all info about event

  - Name, event category, description, time, date, location, contact phone, and contact email address. Location set from map (api?)
  - Event types:
    - [ ] a. Public: seen by everyone
    - [ ] b. Private: seen by university members
    - [ ] c. RSO: seen by members of the RSO

- [ ] Events are approved by super admin

Components needed:

- [x] 1. Login
- [x] 2. Sign up
- [x] 3. Calender Component
- [x] 4. Event Feed Component
- [ ] 5. Event Page Component
- [x] 6. College Profile Component
- [] 7. RSO Profile Component
- [ ] 8. Event Approval Component
- [x] 9. Create event Component
- [x] 10. Create RSO Component

Queries needed:

- [x] 1. Events for a User
  - [x] a. Public
  - [x] b. Private
  - [x] c. RSO
  - [x] d. All
- [ ] 2. Queries for an Event
  - [ ] a. Ratings
  - [ ] b. Comments

university_login
- [x] 1. Add university email to UNI table [SQL]
- [x] 2. On signup check for uni email (after the @) [SQL]
-   [x] a. Add uni to user_info on signup [SQL]
- [x] 3. Add user_info creation to signup [SQL]