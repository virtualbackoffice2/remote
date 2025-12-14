ADDING TESSERACT OCR TO SYSTEM PATH (WINDOWS)

This document explains how to add Tesseract OCR to the Windows
system PATH so it can be accessed from any application or script.


STEP 1: INSTALL TESSERACT OCR
Make sure Tesseract OCR is installed on your system.

The default installation path is usually:
C:\Program Files\Tesseract-OCR\


STEP 2: OPEN ENVIRONMENT VARIABLES
1. Right-click on "This PC" and select "Properties"
2. Click on "Advanced system settings"
3. Click on the "Environment Variables" button


STEP 3: ADD TESSERACT TO PATH
1. In the "System variables" section, select "Path"
2. Click "Edit"
3. Click "New"
4. Add the following path:
   C:\Program Files\Tesseract-OCR\
5. Click OK on all open windows to save changes


STEP 4: VERIFY INSTALLATION (RECOMMENDED)
1. Open Command Prompt
2. Run the following command:
   tesseract --version

If version information is displayed, Tesseract has been added
successfully to the system PATH.


NOTES
- Restart the computer after updating the PATH
- If Tesseract is installed in a different folder, add that exact path
