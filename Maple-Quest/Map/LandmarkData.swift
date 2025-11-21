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
    ),
    Landmark(
        name: "CN Tower",
        province: "Ontario",
        description: "One of the tallest freestanding structures in the world, offering sweeping views of Toronto and Lake Ontario. Visitors can enjoy its glass floor, revolving restaurant, and the thrilling EdgeWalk experience along the tower’s outer ledge.",
        imageName: "cnTower",
        location: CLLocationCoordinate2D(latitude: 43.64272921522629, longitude: -79.38712117632794),
        isVisited: false
    ),
    Landmark(
        name: "Parliament Hill",
        province: "Ontario",
        description: "The center of Canada’s federal government, known for its grand Gothic Revival architecture and rich political history. Overlooking the Ottawa River, the grounds host ceremonial events, tours, and seasonal light shows that celebrate Canadian culture.",
        imageName: "parliamentHill",
        location: CLLocationCoordinate2D(latitude: 45.42375180363914, longitude: -75.70093973205235),
        isVisited: false
    ),
    Landmark(
        name: "Capilano Suspension Bridge",
        province: "British Columbia",
        description: "A 137-metre suspension bridge soaring 70 metres above the Capilano River, surrounded by lush rainforest. The park offers treetop walkways, cliffside adventures, and Indigenous cultural displays that highlight the area’s deep heritage.",
        imageName: "capSuspensionBridge",
        location: CLLocationCoordinate2D(latitude: 49.343021644932385, longitude: -123.1149244029921),
        isVisited: false
    ),
    Landmark(
        name: "Château Frontenac",
        province: "Québec",
        description: "A landmark luxury hotel perched atop Old Québec’s historic district. Its castle-like architecture, elegant interiors, and commanding views of the St. Lawrence River make it one of the most photographed hotels in the world.",
        imageName: "chateauFrontenac",
        location: CLLocationCoordinate2D(latitude: 46.81231686579934, longitude: -71.20521303872079),
        isVisited: false
    ),
    Landmark(
        name: "Peggy’s Cove Lighthouse",
        province: "Nova Scotia",
        description: "A beloved maritime icon set on rugged granite rocks along the Atlantic coast. The lighthouse sits beside a charming fishing village and draws visitors for its dramatic waves, coastal scenery, and classic East Coast charm.",
        imageName: "peggysLighthouse",
        location: CLLocationCoordinate2D(latitude: 44.491936206399686, longitude: -63.91859253025372),
        isVisited: false
    ),
    Landmark(
        name: "The Butchart Gardens",
        province: "British Columbia",
        description: "A world-renowned 55-acre garden estate featuring vibrant floral displays, themed gardens, and peaceful water features. A historic horticultural masterpiece, it offers year-round beauty and enchanting seasonal events.",
        imageName: "theButchartGardens",
        location: CLLocationCoordinate2D(latitude: 48.56392334620516, longitude: -123.47057219248805),
        isVisited: false
    ),
    Landmark(
        name: "Notre-Dame Basilica of Montreal",
        province: "Quebec",
        description: "A breathtaking Gothic Revival basilica known for its richly decorated interior, gold accents, wooden carvings, and vivid stained-glass windows. Its atmospheric lighting and historic pipe organ make it a cultural and architectural treasure.",
        imageName: "notreDameBasilica",
        location: CLLocationCoordinate2D(latitude: 45.50516240416656, longitude: -73.55623292700953),
        isVisited: false
    ),
    Landmark(
        name: "Granville Island",
        province: "British Columbia",
        description: "A vibrant waterfront district filled with artisan studios, independent shops, theatres, and the famous public market. It’s a lively cultural hub where food, creativity, and local craftsmanship meet.",
        imageName: "granvilleIsland",
        location: CLLocationCoordinate2D(latitude: 49.271674401819055, longitude: -123.13418917977187),
        isVisited: false
    ),
    Landmark(
        name: "Casa Loma",
        province: "Ontario",
        description: "A grand Gothic Revival mansion featuring opulent rooms, secret passageways, towers, and beautifully manicured gardens. This historic estate lets visitors step back into Toronto’s early 20th-century elegance.",
        imageName: "casaLoma",
        location: CLLocationCoordinate2D(latitude: 43.678874844218456, longitude: -79.40952611030264),
        isVisited: false
    ),
    Landmark(
        name: "Scotiabank Saddledome",
        province: "Alberta",
        description: "A Calgary landmark recognized for its saddle-shaped roof and long history of hosting major sporting events, concerts, and community gatherings. It stands as a symbol of the city’s lively entertainment scene.",
        imageName: "saddledome",
        location: CLLocationCoordinate2D(latitude: 51.03774490299122, longitude: -114.05194486168853),
        isVisited: false
    ),
    Landmark(
        name: "Jasper National Park",
        province: "Alberta",
        description: "Canada’s largest Rocky Mountain park, known for its dramatic peaks, turquoise lakes, glaciers, and abundant wildlife. A designated Dark Sky Preserve, it offers exceptional stargazing and unforgettable outdoor adventures.",
        imageName: "jasper",
        location: CLLocationCoordinate2D(latitude: 52.873855301572654, longitude: -117.9543686793018),
        isVisited: false
    ),
    Landmark(
        name: "Halifax Citadel",
        province: "Nova Scotia",
        description: "A historic star-shaped fortress overlooking Halifax Harbour. The site features reenactments, military exhibits, guided tours, and panoramic city views that bring centuries of Canadian history to life.",
        imageName: "halifaxCitadel",
        location: CLLocationCoordinate2D(latitude: 44.64848187154006, longitude: -63.579390497947685),
        isVisited: false
    ),
    Landmark(
        name: "Montmorency Falls",
        province: "Quebec",
        description: "A powerful waterfall standing taller than Niagara Falls, surrounded by scenic trails, viewpoints, and a suspension bridge. The site offers dramatic landscapes, seasonal beauty, and immersive outdoor exploration.",
        imageName: "montmorencyFalls",
        location: CLLocationCoordinate2D(latitude: 46.887937226029194, longitude: -71.14779067673727),
        isVisited: false
    ),
    Landmark(
        name: "McDougall Centre",
        province: "Alberta",
        description: "A provincial government office and meeting space, this designated historic resource first opened its doors to students in 1907.",
        imageName: "mccentre",
        location: CLLocationCoordinate2D(latitude: 51.049496, longitude: -114.077365),
        isVisited: false
    )
]
