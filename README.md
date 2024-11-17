# imageMetadataCleaner
The script removes the following metadata:

- **General information**: dimensions, compression, color space
- **Camera**: manufacturer, model, serial number, lens
- **Shooting**: exposure, aperture, ISO, focal length, flash
- **GPS**: latitude, longitude, altitude, timestamp
- **Timestamps**: capture and digitization date/time
- **Rights**: author, copyright
- **Software**: processing and editing information

## Features

- Batch processing of all images in a folder
- Support for common formats (JPG, PNG, HEIC, TIFF)
- Image quality preservation
- Console progress display
- Simple command line usage

## Installation

1. Make sure you have Swift installed on your system
2. Clone this repository: git clone https://github.com/hdrapin/ImageMetadataCleaner.git

## Usage: Command line execution / bash:
  ``swift ImageMetadataCleaner.swift "/path/to/folder" ``

## Requirements

- macOS 10.15 or higher
- Swift 5.0 or higher

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Feel free to:

1. Fork the project
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📧 Contact

For any questions or suggestions, please open an issue on this repository.
