class FileHandler {
    File file

    FileHandler(String filePathAndName){
        file = new File(filePathAndName)
    }

    String readFileContents(){
        // Read contents of file
        return file.text
    }
}
