//
//  LandmarkData.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-13.
//

import CoreLocation
import Foundation

let landmarks: [Landmark] = [
    Landmark(
        name: "Niagara Falls",
        province: "Ontario",
        description: "Niagara Falls is a breathtaking natural wonder on the border of Canada and the United States, known for its massive, powerful waterfalls and misty beauty. It’s a popular destination for sightseeing, boat tours, and stunning views, especially from the Canadian side.",
        imageName: "niagaraFalls",
        location: CLLocationCoordinate2D(latitude: 43.0946853, longitude: -79.039969),
        isVisited: false
    ),
    Landmark(
        name: "Hopewell Rocks Provincial Park",
        province: "New Brunswick",
        description: "Hopewell Rocks Provincial Park in New Brunswick is famous for its towering flowerpot-shaped rock formations carved by the tides of the Bay of Fundy. Visitors can walk on the ocean floor at low tide and kayak among the rocks at high tide for a truly unique experience.",
        imageName: "hopewellRocks",
        location: CLLocationCoordinate2D(latitude: 45.817655, longitude: -64.578458),
        isVisited: false
    ),
    Landmark(
        name: "Banff National Park",
        province: "Alberta",
        description: "Banff National Park, located in the Canadian Rockies, is renowned for its stunning turquoise lakes, majestic mountains, and abundant wildlife. It’s a year-round destination for hiking, skiing, and exploring some of Canada’s most breathtaking natural scenery.",
        imageName: "banff",
        location: CLLocationCoordinate2D(latitude: 51.497408, longitude: -115.926168),
        isVisited: false
    ),
    Landmark(
        name: "University of Calgary",
        province: "Alberta",
        description: "The University of Calgary is a leading Canadian research university known for its innovative programs, vibrant campus life, and strong ties to industry. Located in Alberta’s largest city, it offers world-class education and opportunities in a dynamic, forward-thinking environment.",
        imageName: "uCalgary",
        location: CLLocationCoordinate2D(latitude: 51.07848848773985, longitude: -114.13352874347278),
        isVisited: false
    )
]
