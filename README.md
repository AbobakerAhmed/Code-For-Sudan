# Healthcare Sudan Project

## Overview
The Healthcare Sudan Project is a comprehensive healthcare management system developed for the Code For Sudan Hackathon. It addresses two critical challenges faced by the Sudanese population in the medical field:
1. **Delayed epidemic detection and response**, which often leads to widespread outbreaks and loss of life.
2. **Difficulties in accessing medical care**, including long wait times, lack of information about hospital services, and inefficient appointment systems.

###
The system consists of three interconnected applications designed to streamline healthcare services, improve communication, and enhance data management for citizens, healthcare providers, and ministry employees.

## System Components

### 1. Mobile App
- **Target Users**: Citizens, Registrars, Doctors.
- **Key Features**:
  - Appointment booking and management.
  - Access to emergency numbers and medical advice.
  - Notifications for appointment updates and epidemics.
  - Medical history management (for citizens and doctors).
  - Offline functionality for critical features.

### 2. Hospital Desktop App
- **Target Users**: Hospital Managers, Health Officers.
- **Key Features**:
  - Staff management (add/edit/remove registrars, doctors, health officers).
  - Clinical data recording (admissions, discharges, operations, deaths).
  - Appointment and queue management.
  - Dashboard for analytics and reporting.
  - Notifications to/from ministry and staff.

### 3. Ministry Desktop App
- **Target Users**: Ministry Employees.
- **Key Features**:
  - Hospital and staff management (add/edit hospitals, departments, managers).
  - Epidemic monitoring and reporting.
  - Sending notifications and medical advice to citizens.
  - Generating and exporting reports (PDF).
  - Regional data filtering (state, locality, hospital, date).

## Key Features

### For Citizens
- Sign up and manage profiles.
- Book appointments for themselves or others.
- View emergency numbers and medical advice.
- Receive appointment and epidemic notifications.

### For Healthcare Providers
- **Registrars**: Manage appointments (online/offline), send notifications, and handle patient queues.
- **Doctors**: Diagnose patients, record epidemics, and update medical histories.
- **Hospital Managers**: Oversee staff, clinical data, and generate reports for the ministry.
- **Health Officers**: Maintain patient records and filter appointment data.

### For Ministry Employees
- Manage hospitals, departments, and staff.
- Monitor epidemics and send critical alerts.
- Generate reports and dashboards for decision-making.
- Communicate with hospitals and citizens.

## Technical Requirements (Still in progress)

### Security 
- Passwords stored as encoded and salted hashes.
- HTTPS encryption for all signups and logins.
- Automatic logout after 1 hour of inactivity (ministry app).

### Performance
- Supports up to 500 concurrent users (ministry app).
- Dashboard loads within 5 seconds (95% of requests).
- Mobile app size under 40 MB.

### Usability
- Arabic language support.
- Responsive design for all screen sizes (mobile and desktop).
- User-friendly interfaces with actions accessible within 5 clicks (desktop).

## Demo vedio to explaining how to use it

https://youtu.be/QH7dAVxit0o?si=SFU-5j5OKijSRuIe

## Installation and Setup
1. **Mobile App**:
  - Clone the repository:
   git clone https://github.com/AbobakerAhmed/Code-For-Sudan.git

  - Navigate to the project directory:
  cd healthcare-sudan
   
- ### The next 2 steps still in progr
  - Download from the respective app store (link to be provided).
  - Minimum requirements: Android/iOS with 40 MB free space.

2. **Desktop Apps (Still in progress)**:
   - Download the installer from the project repository.
   - Run the installer and follow on-screen instructions.
   - Ensure stable internet connection for initial setup.

## For more understading check
  - **UMLs** : 
    data_structure/UML
  - **Data structure** : 
    data_structure
  - **v1.2 ppt** : 
    Pre-Processing/Health_Sudan_SRS_v1.2.pptx
  - **The upcoming in v2** :      
    Health-Epidemic-Detection-(V2 Features_).md
  - **The network issues and how to fix it** :
    Health-Epidemic-Detection-(Networks Issues_).md

## Contributors
- Developed by the Code For Sudan Hackathon team.


## License
This project is licensed under [MIT]. See the `LICENSE` file for details.