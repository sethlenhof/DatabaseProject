- [x] 1. Create a login page
  - [x] add login button functionality
- [x] 2. Create a sign up page
  - [x] add sign up button functionality
- [x] 3. Create main landing page: shows all events
- [ ] 4. Research showing data from events.ucf
- [ ] 5. Add additional info for different users
  - [X] a. Super admin: create profile for university
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


TO DO UPDATED:
- [X] 1. Create RSO endpoint wired up to the component
  -[X] a. update the form if needed
  -[x] b. update the procedure
  -[X] c. create the endpoint to create an RSO
  -[O] d. validate that there are 4 emails and the users exist
  -[X] e. wire together with api

- [X] 2. Join RSOs
  -[X] a. GET RSO endpoint
  -[X] b. populate onto the join rso modal
  -[X] c. Join buttons next to each RSO
  -[X] d. POST to join the RSO
  -[X] e. Wire to front end, show toast

- [ ] 3. Create Events
  -[X] a. GET to determine RSO(S)
  -[ ] b. Add dropdown and adjust form as needed if multiple RSOs
  -[ ] c. Ensure form has all fields needed, adjust to match db
  -[X] d. Create procedure to add event given a USERID, RSO/UNI id
  -[X] e. Create post endpoint to add event
  -[ ] f. Wire to front end, show toasts

- [X] 4. Get events
  -[X] a. Procedure to find all events for userId
    -[X] I. RSO events
    -[X] II. private (university) events
    -[X] III. public events
    -[X] IV. approved events
  -[X] b. GET Events endpoint
  -[X] c. populate onto the calendar and scrollable (wire together)

- [ ] 5. Event page
  -[X] a. Procedure to get all event data for event by eventId
  -[X] b. GET event_data endpoint
  -[ ] c. populate onto event page
    -[ ] i. show comments
    -[ ] ii. add comments

- [X] 6. Approve Events
  -[X] a. GET Unnaproved_events endpoint
  -[X] b. populate onto a modal
  -[X] c. Approve buttons next to each event
  -[X] d. POST to approve the event
  -[X] e. Wire to front end, show toast

THINGS WE CAN "WORK ON":
- [ ] 1. Constraints
  - [ ] a. new events being held at the same location and time
  - [ ] b. admins of other RSOs trying to create an event for another RSO (weird?)
  - [ ] c. inserting a member of an RSO with 4 members changing to active (ig. they can make one but not have 4 and it be "inactive"?)
  - [ ] d. a delete of an RSO with 5 members "show the status of the RSO changing to inactive"

IDK IF WE NEED:
- [ ] 1. User Profile page to update info
  -[ ] a. Update info form
  -[ ] b. procedure for update (this can all be followed from the update university pretty quickly)
  -[ ] c. POST to update the info
  -[ ] d. wire the endpoint


THINGS TO THINK ABOUT: When a student becomes an RSO admin what happens? do they still remain a student, in the table, will our procedure work still for determining that
