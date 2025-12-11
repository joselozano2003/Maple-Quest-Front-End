//
//  LandmarkData.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-13.
//

import CoreLocation
import Foundation

// Landmark data
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
    ),
    Landmark(
        name: "Moraine Lake",
        province: "Alberta",
        description: "This glacier-fed lake features unreal bright-blue water surrounded by the Valley of the Ten Peaks. It’s a bucket-list sunrise spot and one of Canada’s most iconic views.",
        imageName: "moraineLake",
        location: CLLocationCoordinate2D(latitude: 51.328239, longitude: -116.181717),
        isVisited: false
    ),
    Landmark(
        name: "Old Quebec",
        province: "Quebec",
        description: "A UNESCO World Heritage Site known for its European charm and cobblestone streets. The fortified walls make it the only walled city north of Mexico.",
        imageName: "oldQuebec",
        location: CLLocationCoordinate2D(latitude: 46.812182, longitude: -71.206493),
        isVisited: false
    ),
    Landmark(
        name: "Whistler",
        province: "British Columbia",
        description: "A top global ski destination with year-round hiking, biking, and sightseeing. The PEAK 2 PEAK Gondola links Whistler and Blackcomb mountains with epic views.",
        imageName: "whistler",
        location: CLLocationCoordinate2D(latitude: 50.116322, longitude: -122.957359),
        isVisited: false
    ),
    Landmark(
        name: "Cabot Trail",
        province: "Nova Scotia",
        description: "A scenic coastal drive looping around Cape Breton Island. Known for whale watching, dramatic cliffs, and autumn foliage.",
        imageName: "cabotTrail",
        location: CLLocationCoordinate2D(latitude: 46.486942, longitude: -60.746113),
        isVisited: false
    ),

    Landmark(
        name: "Gros Morne National Park",
        province: "Newfoundland and Labrador",
        description: "A UNESCO site showcasing fjords, cliffs, and rare geology. The Western Brook Pond fjord is a bucket-list cruise.",
        imageName: "grosMorne",
        location: CLLocationCoordinate2D(latitude: 49.6870, longitude: -57.7360),
        isVisited: false
    ),
    Landmark(
        name: "Churchill",
        province: "Manitoba",
        description: "Known as the polar bear capital of the world. It’s also one of the best places to see beluga whales and the Northern Lights.",
        imageName: "churchill",
        location: CLLocationCoordinate2D(latitude: 58.768410, longitude: -94.164963),
        isVisited: false
    ),
    Landmark(
        name: "Prince Edward Island National Park",
        province: "Prince Edward Island",
        description: "Home to red-sand beaches, dunes, and Anne of Green Gables heritage sites. Perfect for cycling or relaxing seaside.",
        imageName: "peiPark",
        location: CLLocationCoordinate2D(latitude: 46.4550, longitude: -62.8500),
        isVisited: false
    ),
    Landmark(
        name: "Mont Tremblant",
        province: "Quebec",
        description: "A charming ski resort village with strong European vibes. Popular for skiing, hiking, and spa getaways.",
        imageName: "montTremblant",
        location: CLLocationCoordinate2D(latitude: 46.1183, longitude: -74.5965),
        isVisited: false
    ),
    Landmark(
        name: "Vancouver Seawall",
        province: "British Columbia",
        description: "The world’s longest uninterrupted waterfront path. Perfect for biking past beaches, forests, and city skyline views.",
        imageName: "vancouverSeawall",
        location: CLLocationCoordinate2D(latitude: 49.3043, longitude: -123.1443),
        isVisited: false
    ),
    Landmark(
        name: "Thousand Islands",
        province: "Ontario",
        description: "An archipelago of over 1,800 islands scattered along the St. Lawrence River. Boat tours reveal mansions, castles, and crystal-clear waters.",
        imageName: "thousandIslands",
        location: CLLocationCoordinate2D(latitude: 44.3540, longitude: -75.8969),
        isVisited: false
    ),
    Landmark(
        name: "Haida Gwaii",
        province: "British Columbia",
        description: "A remote archipelago known for Indigenous Haida culture and untouched landscapes. Its ancient totems and mossy forests feel almost mythical.",
        imageName: "haidaGwaii",
        location: CLLocationCoordinate2D(latitude: 53.2537, longitude: -132.0457),
        isVisited: false
    ),
    Landmark(
        name: "Tofino",
        province: "British Columbia",
        description: "A laid-back surf town surrounded by rainforest and beaches. Perfect for surfing, storm watching, and relaxing hot springs.",
        imageName: "tofino",
        location: CLLocationCoordinate2D(latitude: 49.1520, longitude: -125.9050),
        isVisited: false
    ),
    Landmark(
        name: "Kananaskis Country",
        province: "Alberta",
        description: "Often overshadowed by Banff, it offers equally stunning mountains with fewer crowds. Ideal for hiking, wildlife sightings, and serenity.",
        imageName: "kananaskis",
        location: CLLocationCoordinate2D(latitude: 50.8860, longitude: -115.0667),
        isVisited: false
    ),
    Landmark(
        name: "Waterton Lakes National Park",
        province: "Alberta",
        description: "A lesser-known national park joining Glacier National Park across the U.S. border. Its lake views, red canyon, and Prince of Wales Hotel are stunning.",
        imageName: "waterton",
        location: CLLocationCoordinate2D(latitude: 49.0833, longitude: -113.9167),
        isVisited: false
    ),
    Landmark(
        name: "Nahanni National Park",
        province: "Northwest Territories",
        description: "A remote UNESCO site known for deep canyons and Virginia Falls—twice the height of Niagara. Accessible mainly by floatplane, making it a true adventure.",
        imageName: "nahanni",
        location: CLLocationCoordinate2D(latitude: 61.0000, longitude: -124.5000),
        isVisited: false
    ),
    Landmark(
        name: "Fogo Island",
        province: "Newfoundland and Labrador",
        description: "A rugged island with modern art retreats and coastal hikes. The Fogo Island Inn is world-renowned for its architecture.",
        imageName: "fogoIsland",
        location: CLLocationCoordinate2D(latitude: 49.6670, longitude: -54.2100),
        isVisited: false
    ),
    Landmark(
        name: "Athabasca Sand Dunes",
        province: "Saskatchewan",
        description: "The world’s northernmost sand dunes, stretching up to 30 metres high. A surreal desert-like landscape in the middle of Canada’s wilderness.",
        imageName: "athabascaDunes",
        location: CLLocationCoordinate2D(latitude: 59.08326157208747, longitude: -109.0699118801578),
        isVisited: false
    ),
    Landmark(
        name: "Manitoulin Island",
        province: "Ontario",
        description: "The world's largest freshwater island. Its Indigenous culture and crystal-clear lakes make it peaceful and unique.",
        imageName: "manitoulinIsland",
        location: CLLocationCoordinate2D(latitude: 45.8220, longitude: -82.3400),
        isVisited: false
    ),
    Landmark(
        name: "Dinosaur Provincial Park",
        province: "Alberta",
        description: "A badlands area rich in fossils and hoodoos. Over 50 dinosaur species have been discovered here.",
        imageName: "dinosaurPark",
        location: CLLocationCoordinate2D(latitude: 50.6985, longitude: -112.2595),
        isVisited: false
    ),
    Landmark(
        name: "Whitehorse & Miles Canyon",
        province: "Yukon",
        description: "Bright green waters run between dramatic basalt cliffs. It’s a beautiful and quiet spot just minutes from the city.",
        imageName: "milesCanyon",
        location: CLLocationCoordinate2D(latitude: 60.6400, longitude: -135.0860),
        isVisited: false
    ),
    Landmark(
        name: "Cape Spear",
        province: "Newfoundland and Labrador",
        description: "The easternmost point in North America. Visitors can catch the continent’s first sunrise and explore WWII bunkers.",
        imageName: "capeSpear",
        location: CLLocationCoordinate2D(latitude: 47.5235, longitude: -52.6231),
        isVisited: false
    ),
    Landmark(
        name: "Spirit Island",
        province: "Alberta",
        description: "An iconic, secluded island surrounded by towering peaks. Accessible only by boat, it’s one of the most picturesque places in the Rockies.",
        imageName: "spiritIsland",
        location: CLLocationCoordinate2D(latitude: 52.7290, longitude: -117.6480),
        isVisited: false
    ),
    Landmark(
        name: "Cape Bonavista Lighthouse",
        province: "Newfoundland and Labrador",
        description: "A historic lighthouse set on dramatic sea cliffs overlooking the Atlantic. Visitors can climb the restored 1843 tower, watch puffins, and spot passing icebergs in spring.",
        imageName: "capeBonavista",
        location: CLLocationCoordinate2D(latitude: 48.6494, longitude: -53.1125),
        isVisited: false
    ),
    Landmark(
        name: "Mount Carleton Provincial Park",
        province: "New Brunswick",
        description: "Remote highland wilderness containing the highest peak in the Maritime Provinces, offering hiking, lakes, forested hills — a quiet wilderness escape.",
        imageName: "mountCarleton",
        location: CLLocationCoordinate2D(latitude: 47.4065, longitude: -66.8185),
        isVisited: false
    ),
    Landmark(
        name: "Percé Rock",
        province: "Québec",
        description: "A massive limestone rock formation rising from the sea off the tip of the Gaspé Peninsula — one of the world’s largest natural sea‑arches and a symbol of Quebec’s coastal wilderness.",
        imageName: "perceRock",
        location: CLLocationCoordinate2D(latitude: 48.6360, longitude: -64.2130),
        isVisited: false
    ),
    Landmark(
        name: "Mingan Archipelago",
        province: "Québec",
        description: "A chain of limestone islands and sea‑stacks carved by wind and waves along the Gulf of St. Lawrence — surreal coastal scenery, great for kayaking, bird‑watching, and remote camping.",
        imageName: "minganArchipelago",
        location: CLLocationCoordinate2D(latitude: 50.2790, longitude: -63.6130),
        isVisited: false
    ),
    Landmark(
        name: "Grasslands National Park",
        province: "Saskatchewan",
        description: "Sweeping prairie landscapes, wide open skies, native grassland, and chances to see bison, pronghorn and other wildlife — a tranquil, underappreciated prairie wilderness.",
        imageName: "grasslandsNationalPark",
        location: CLLocationCoordinate2D(latitude: 49.9670, longitude: -107.4500),
        isVisited: false
    ),
    Landmark(
        name: "Tombstone Territorial Park",
        province: "Yukon",
        description: "Jagged peaks, tundra landscapes and remote northern wilderness — often dubbed \"Canada’s Patagonia.\" Great for multi‑day treks, wildlife viewing and seeing tundra flora, especially spectacular in fall when colours explode.",
        imageName: "tombstoneTerritorialPark",
        location: CLLocationCoordinate2D(latitude: 63.0000, longitude: -137.0000),
        isVisited: false
    ),
    Landmark(
        name: "Wasson Bluff",
        province: "Nova Scotia",
        description: "A series of sandstone and basalt cliffs along the Minas Basin that preserve fossils from the Triassic–Jurassic boundary, offering a rare glimpse into ancient life and dramatic tide‑shaped geology.",
        imageName: "wassonBluff",
        location: CLLocationCoordinate2D(latitude: 45.4150, longitude: -64.2420),
        isVisited: false
    ),
    Landmark(
        name: "Paskapoo Slopes",
        province: "Alberta",
        description: "A natural sandstone escarpment and ravine‑cut slopes on Calgary’s western edge, formed by glacial lakes and erosion — a quiet but striking geological feature near urban Alberta.",
        imageName: "paskapooSlopes",
        location: CLLocationCoordinate2D(latitude: 51.0333, longitude: -114.1667),
        isVisited: false
    ),
    Landmark(
        name: "Port Renfrew",
        province: "British Columbia",
        description: "On Vancouver Island’s rugged west coast — wild beaches, old‑growth forest, tide‑pools, and proximity to ancient giants in nearby groves. Great for those wanting remote coastlines minus the crowds.",
        imageName: "portRenfrew",
        location: CLLocationCoordinate2D(latitude: 48.5500, longitude: -124.5667),
        isVisited: false
    ),
    Landmark(
        name: "Galiano Island",
        province: "British Columbia",
        description: "A quieter member of the Southern Gulf Islands — a laid‑back, artsy island with coastal trails, kayaking, local galleries and a relaxed island‑life vibe close to Vancouver.",
        imageName: "galianoIsland",
        location: CLLocationCoordinate2D(latitude: 49.4490, longitude: -123.3790),
        isVisited: false
    )
]
