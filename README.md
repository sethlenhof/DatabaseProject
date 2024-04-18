# DatabaseProject

Database project: Maximus Smith and Seth Lenhof
COP 4710

# Project Setup Instructions

### Cloning the Repository:
1. Clone the repository to your local machine:
   git clone https://github.com/sethlenhof/DatabaseProject

### Installing Dependencies:
2. Navigate to the main directory of the project:
   ```bash
   cd DatabaseProject
   npm install
   ```
3. Move to the frontend directory and install its dependencies:
   ```bash
   cd frontend
   npm install
   cd ..
   ```
### Setting Up the Database:
4. Ensure MySQL is running and set up the database:
   ```bash
   mysql < create_ems_db.sql
   ```
### Running the Application:
5. From the main directory, start both the frontend and backend:
   ```bash
   npm run dev
   ```
Now, you should have the application running successfully!
