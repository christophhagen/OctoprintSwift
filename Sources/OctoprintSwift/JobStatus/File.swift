import Foundation

struct File {

    let date: Date?

    /**
     The name of the file or folder without path.

     E.g. “file.gco” for a file “file.gco” located anywhere in the file system. Currently this will always fit into ASCII.
     */
    let name: String?

    /**
     The name of the file without the path, this potentially with non-ASCII unicode characters.

     E.g. “a turtle 🐢.gco” for a file “a_turtle_turtle.gco” located anywhere in the file system.
     */
    let display: String?

    /**
     The path to the file or folder within the location.

     E.g. “folder/subfolder/file.gco” for a file “file.gco” located within “folder” and “subfolder” relative to the root of the location. Currently this will always fit into ASCII.
     */
    let path: String?

    /**
     The origin of the file, local when stored in OctoPrint’s uploads folder, sdcard when stored on the printer’s SD card (if available)
     */
    let origin: Origin?

    let size: Int?

    /**
     References relevant to this file or folder, left out in abridged version
     */
    //let refs: Reference?
}

extension File: Codable {

}

extension File: Equatable {

}

extension File {

    enum Origin: String {
        case local
        case sdcard
    }
}

extension File.Origin: Codable {

}

extension File.Origin: Equatable {

}
