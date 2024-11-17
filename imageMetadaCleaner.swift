//
//  ImageMetadataCleaner.swift
//
//  A Swift script to remove EXIF metadata from images while preserving image quality.
//
//  Features:
//  - Batch processing of images in a directory
//  - Supports JPG, JPEG, PNG, HEIC, TIFF formats
//  - Removes all EXIF metadata including:
//    * GPS location data
//    * Camera information
//    * Date/time stamps
//    * Device details
//    * Copyright information
//
//  Usage:
//  - Command line: swift ImageMetadataCleaner.swift /path/to/folder
//  - In code: let cleaner = ImageMetadataCleaner()
//            cleaner.cleanDirectoryMetadata(at: "/path/to/folder")
//
//  Created by: HD Rapin
//  Version: 1.0.0
//  License: MIT
//


import Foundation
import ImageIO
import UniformTypeIdentifiers

class ImageMetadataCleaner {
    
    // Supported image formats
    private let supportedExtensions = ["jpg", "jpeg", "png", "heic", "tiff"]
    
    // Main function to process a directory
    func cleanDirectoryMetadata(at path: String) {
        // Create URL from path and handle potential spaces
        let directoryURL = URL(fileURLWithPath: path.replacingOccurrences(of: "\\", with: ""))
        
        do {
            let fileURLs = try getImageURLs(from: directoryURL)
            
            if fileURLs.isEmpty {
                print("⚠️ No supported images found in directory")
                return
            }
            
            for fileURL in fileURLs {
                do {
                    try cleanImageMetadata(at: fileURL)
                    print("✅ Metadata cleaned: \(fileURL.lastPathComponent)")
                } catch {
                    print("❌ Error processing \(fileURL.lastPathComponent): \(error.localizedDescription)")
                }
            }
        } catch {
            print("❌ Error reading directory: \(error.localizedDescription)")
        }
    }
    
    // Get all image URLs from the directory
    private func getImageURLs(from directoryURL: URL) throws -> [URL] {
        let fileURLs = try FileManager.default.contentsOfDirectory(
            at: directoryURL,
            includingPropertiesForKeys: nil
        )
        
        return fileURLs.filter { url in
            supportedExtensions.contains(url.pathExtension.lowercased())
        }
    }
    
    // Clean metadata from an image
    private func cleanImageMetadata(at url: URL) throws {
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil),
              let type = CGImageSourceGetType(imageSource) else {
            throw MetadataError.unableToReadImage
        }
        
        // Create a new image without metadata
        let options: CFDictionary = [
            kCGImageSourceShouldCache: false,
            kCGImageDestinationMetadata: [:] as CFDictionary
        ] as CFDictionary
        
        guard let destination = CGImageDestinationCreateWithURL(
            url as CFURL,
            type,
            1,
            nil
        ) else {
            throw MetadataError.unableToCreateDestination
        }
        
        // Copy the image without metadata
        guard let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            throw MetadataError.unableToCreateImage
        }
        
        CGImageDestinationAddImage(destination, image, options)
        
        if !CGImageDestinationFinalize(destination) {
            throw MetadataError.unableToSaveImage
        }
    }
    
    // Possible errors
    enum MetadataError: Error {
        case unableToReadImage
        case unableToCreateDestination
        case unableToCreateImage
        case unableToSaveImage
        
        var localizedDescription: String {
            switch self {
            case .unableToReadImage:
                return "Unable to read image"
            case .unableToCreateDestination:
                return "Unable to create destination"
            case .unableToCreateImage:
                return "Unable to create new image"
            case .unableToSaveImage:
                return "Unable to save image"
            }
        }
    }
}

// Script usage
if CommandLine.arguments.count > 1 {
    let folderPath = CommandLine.arguments[1]
    let cleaner = ImageMetadataCleaner()
    cleaner.cleanDirectoryMetadata(at: folderPath)
} else {
    print("❌ Please provide a folder path")
    print("Usage: swift ImageMetadataCleaner.swift \"/path/to/folder\"")
}
