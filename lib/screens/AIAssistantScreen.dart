import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';
import '../theme/AppThemes.dart';

// --- Data models ---

enum MealCategory { vegetables, meat, seafood, rice, noodles, soup, all }

class _Meal {
  final String name;
  final List<String> ingredients;
  final double cost;
  final MealCategory category;
  final bool isVegetarian;
  const _Meal(
    this.name,
    this.ingredients,
    this.cost, {
    this.category = MealCategory.all,
    this.isVegetarian = false,
  });
}

class _DayPlan {
  final String day;
  final _Meal breakfast;
  final _Meal lunch;
  final _Meal dinner;
  final _Meal snack;
  const _DayPlan(this.day, this.breakfast, this.lunch, this.dinner, this.snack);
  double get total => breakfast.cost + lunch.cost + dinner.cost + snack.cost;
}

// --- Static meal database with 50+ dishes per category ---

class _MealDB {
  // ---------- BREAKFASTS (50+ items with category variety) ----------
  static const List<_Meal> breakfasts = [
    // Rice-based breakfasts
    _Meal(
      'Sinangag + Itlog',
      ['Leftover rice', '2 eggs', 'Garlic', 'Oil'],
      18,
      category: MealCategory.rice,
    ),
    _Meal(
      'Sinangag + Daing',
      ['Rice', 'Dried fish', 'Garlic', 'Vinegar'],
      30,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Tapsilog',
      ['Tapa', 'Rice', 'Egg', 'Vinegar'],
      45,
      category: MealCategory.meat,
    ),
    _Meal(
      'Longsilog',
      ['Longganisa', 'Rice', 'Egg', 'Vinegar'],
      40,
      category: MealCategory.meat,
    ),
    _Meal(
      'Tosilog',
      ['Tocino', 'Rice', 'Egg', 'Vinegar'],
      42,
      category: MealCategory.meat,
    ),
    _Meal(
      'Corned Beef Silog',
      ['Canned corned beef', 'Onion', 'Garlic', 'Rice'],
      45,
      category: MealCategory.meat,
    ),
    _Meal(
      'Spam Silog',
      ['Spam', '2 eggs', 'Rice'],
      38,
      category: MealCategory.meat,
    ),
    _Meal(
      'Hotdog Silog',
      ['2 hotdogs', '2 eggs', 'Rice'],
      32,
      category: MealCategory.meat,
    ),
    _Meal(
      'Bangus Silog',
      ['Daing na bangus', 'Rice', 'Egg', 'Vinegar'],
      48,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Chicken Tocino',
      ['Chicken tocino', 'Rice', 'Egg'],
      42,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Adobo Silog',
      ['Adobo flakes', 'Rice', 'Egg'],
      45,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chicken Adobo Silog',
      ['Shredded chicken adobo', 'Rice', 'Egg'],
      44,
      category: MealCategory.meat,
    ),
    _Meal(
      'Beef Tapa Silog',
      ['Beef tapa', 'Rice', 'Egg'],
      50,
      category: MealCategory.meat,
    ),
    _Meal(
      'Bangsilog',
      ['Grilled bangus', 'Rice', 'Egg'],
      52,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Chorizo Silog',
      ['Chorizo', 'Rice', 'Egg'],
      42,
      category: MealCategory.meat,
    ),

    // Soup/porridge breakfasts
    _Meal(
      'Lugaw',
      ['Rice', 'Ginger', 'Garlic', 'Salt'],
      12,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Arroz Caldo',
      ['Rice', 'Chicken bits', 'Ginger', 'Onion'],
      35,
      category: MealCategory.soup,
    ),
    _Meal(
      'Goto',
      ['Rice', 'Beef tripe', 'Ginger', 'Garlic'],
      40,
      category: MealCategory.soup,
    ),
    _Meal(
      'Champorado',
      ['Malagkit rice', 'Cocoa powder', 'Sugar', 'Milk'],
      20,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Champorado + Tuyo',
      ['Malagkit rice', 'Cocoa', 'Sugar', 'Dried fish'],
      32,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Batchoy',
      ['Noodles', 'Pork', 'Liver', 'Broth'],
      45,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Mami',
      ['Egg noodles', 'Chicken', 'Broth', 'Veggies'],
      40,
      category: MealCategory.noodles,
    ),

    // Bread-based breakfasts
    _Meal(
      'Pandesal + Kape',
      ['3 pcs pandesal', 'Instant coffee', 'Sugar'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Tinapay + Itlog',
      ['Bread', '2 eggs', 'Margarine'],
      22,
      category: MealCategory.all,
    ),
    _Meal(
      'Pandesal + Cheese',
      ['3 pcs pandesal', 'Cheese slice'],
      18,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Pandesal + Corned Beef',
      ['3 pcs pandesal', 'Corned beef'],
      32,
      category: MealCategory.meat,
    ),
    _Meal(
      'French Toast',
      ['Bread', 'Egg', 'Milk', 'Sugar'],
      25,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Ensaymada + Tsokolate',
      ['Ensaymada', 'Tablea chocolate'],
      28,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Pan de Coco',
      ['2 pcs pan de coco'],
      12,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Spanish Bread',
      ['2 pcs spanish bread'],
      18,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Kababayan',
      ['3 pcs kababayan'],
      10,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Cheese Bread',
      ['2 pcs cheese bread'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Ube Pandesal',
      ['2 pcs ube pandesal'],
      18,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Monay',
      ['2 pcs monay'],
      10,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Puto',
      ['3 pcs puto', 'Grated coconut'],
      12,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Kutsinta',
      ['3 pcs kutsinta', 'Grated coconut'],
      12,
      category: MealCategory.all,
      isVegetarian: true,
    ),

    // Healthy/light breakfasts
    _Meal(
      'Oatmeal + Saging',
      ['Oats', '1 banana', 'Sugar', 'Milk'],
      25,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Oatmeal + Mansanas',
      ['Oats', 'Apple', 'Cinnamon', 'Honey'],
      28,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Cereal + Gatas',
      ['Cereal', 'Milk', 'Sugar'],
      20,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Fruit Salad',
      ['Mixed fruits', 'Cream', 'Sugar'],
      28,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Yogurt + Granola',
      ['Yogurt', 'Granola', 'Honey'],
      35,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Scrambled Eggs + Toast',
      ['3 eggs', 'Toast', 'Margarine'],
      28,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Omelette',
      ['3 eggs', 'Onion', 'Tomato', 'Garlic'],
      25,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Vegetable Omelette',
      ['3 eggs', 'Bell pepper', 'Onion', 'Mushroom'],
      30,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Tortang Talong',
      ['Eggplant', '2 eggs', 'Garlic', 'Oil'],
      35,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Tortang Giniling',
      ['Ground pork', 'Potato', 'Egg', 'Peas'],
      45,
      category: MealCategory.meat,
    ),

    // Pancakes and desserts
    _Meal(
      'Pancake',
      ['Pancake mix', 'Syrup', 'Margarine'],
      25,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Hotcake + Margarine',
      ['Hotcake mix', 'Margarine', 'Sugar'],
      22,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Bibingka',
      ['1 slice bibingka', 'Grated coconut', 'Egg'],
      25,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Puto Bumbong',
      ['Puto bumbong', 'Grated coconut', 'Sugar'],
      30,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Palitaw',
      ['3 pcs palitaw', 'Sesame seeds', 'Sugar'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
  ];

  // ---------- LUNCHES (50+ items per category) ----------
  static const List<_Meal> lunches = [
    // MEAT DISHES (50)
    _Meal(
      'Adobong Manok',
      ['Chicken', 'Soy sauce', 'Vinegar', 'Garlic'],
      70,
      category: MealCategory.meat,
    ),
    _Meal(
      'Adobong Baboy',
      ['Pork', 'Soy sauce', 'Vinegar', 'Bay leaf'],
      75,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Adobo sa Gata',
      ['Pork', 'Coconut milk', 'Soy sauce', 'Vinegar'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chicken Adobo sa Gata',
      ['Chicken', 'Coconut milk', 'Soy sauce', 'Vinegar'],
      82,
      category: MealCategory.meat,
    ),
    _Meal(
      'Menudo',
      ['Pork', 'Potato', 'Carrot', 'Tomato sauce'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Menudo with Liver',
      ['Pork', 'Liver', 'Potato', 'Carrot'],
      88,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Giniling',
      ['Ground pork', 'Potato', 'Carrot', 'Peas'],
      70,
      category: MealCategory.meat,
    ),
    _Meal(
      'Bicol Express',
      ['Pork', 'Coconut milk', 'Shrimp paste', 'Chili'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Kaldereta',
      ['Beef', 'Tomato sauce', 'Potato', 'Carrot'],
      95,
      category: MealCategory.meat,
    ),
    _Meal(
      'Beef Kaldereta',
      ['Beef', 'Liver spread', 'Tomato sauce', 'Olives'],
      100,
      category: MealCategory.meat,
    ),
    _Meal(
      'Mechado',
      ['Beef', 'Tomato sauce', 'Potato', 'Soy sauce'],
      92,
      category: MealCategory.meat,
    ),
    _Meal(
      'Afritada',
      ['Chicken', 'Tomato sauce', 'Potato', 'Carrot'],
      78,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Afritada',
      ['Pork', 'Tomato sauce', 'Potato', 'Bell pepper'],
      80,
      category: MealCategory.meat,
    ),
    _Meal(
      'Lechon Kawali',
      ['Pork belly', 'Salt', 'Pepper', 'Oil'],
      95,
      category: MealCategory.meat,
    ),
    _Meal(
      'Crispy Pata',
      ['Pork leg', 'Garlic', 'Salt', 'Oil'],
      180,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pata Tim',
      ['Pork leg', 'Soy sauce', 'Star anise', 'Brown sugar'],
      150,
      category: MealCategory.meat,
    ),
    _Meal(
      'Humba',
      ['Pork', 'Pineapple', 'Soy sauce', 'Vinegar'],
      82,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Barbecue',
      ['Pork slices', 'Soy sauce', 'Banana ketchup', 'Garlic'],
      75,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chicken Barbecue',
      ['Chicken thighs', 'Soy sauce', 'Kalamansi', 'Garlic'],
      70,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chicken Curry',
      ['Chicken', 'Coconut milk', 'Curry powder', 'Potato'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Curry',
      ['Pork', 'Coconut milk', 'Curry powder', 'Potato'],
      82,
      category: MealCategory.meat,
    ),
    _Meal(
      'Beef Curry',
      ['Beef', 'Coconut milk', 'Curry powder', 'Potato'],
      95,
      category: MealCategory.meat,
    ),
    _Meal(
      'Bistek Tagalog',
      ['Beef', 'Soy sauce', 'Calamansi', 'Onion'],
      88,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Steak',
      ['Pork', 'Soy sauce', 'Calamansi', 'Onion'],
      72,
      category: MealCategory.meat,
    ),
    _Meal(
      'Beef Steak',
      ['Beef', 'Soy sauce', 'Calamansi', 'Onion'],
      95,
      category: MealCategory.meat,
    ),
    _Meal(
      'Igado',
      ['Pork', 'Liver', 'Peas', 'Carrot'],
      78,
      category: MealCategory.meat,
    ),
    _Meal(
      'Dinuguan',
      ['Pork blood', 'Pork meat', 'Vinegar', 'Chili'],
      70,
      category: MealCategory.meat,
    ),
    _Meal(
      'Crispy Dinuguan',
      ['Crispy pork', 'Pork blood', 'Vinegar', 'Chili'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Sisig',
      ['Pork face', 'Chicken liver', 'Onion', 'Calamansi'],
      90,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Sisig',
      ['Pork belly', 'Onion', 'Chili', 'Calamansi'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chicken Sisig',
      ['Chicken', 'Onion', 'Chili', 'Mayonnaise'],
      80,
      category: MealCategory.meat,
    ),
    _Meal(
      'Lechon Paksiw',
      ['Leftover lechon', 'Vinegar', 'Garlic', 'Liver sauce'],
      70,
      category: MealCategory.meat,
    ),
    _Meal(
      'Rellenong Manok',
      ['Whole chicken', 'Ground pork', 'Egg', 'Pickles'],
      120,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chicken Pastel',
      ['Chicken', 'Cream', 'Mushroom', 'Bell pepper'],
      95,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Asado',
      ['Pork', 'Soy sauce', 'Star anise', 'Brown sugar'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Tapa',
      ['Beef', 'Soy sauce', 'Calamansi', 'Garlic'],
      80,
      category: MealCategory.meat,
    ),
    _Meal(
      'Beef Tapa',
      ['Beef sirloin', 'Soy sauce', 'Garlic', 'Sugar'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Tapa',
      ['Pork', 'Soy sauce', 'Garlic', 'Sugar'],
      70,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chicken Tapa',
      ['Chicken breast', 'Soy sauce', 'Garlic', 'Sugar'],
      68,
      category: MealCategory.meat,
    ),
    _Meal(
      'Longganisa',
      ['Pork longganisa', 'Garlic', 'Vinegar'],
      60,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chorizo',
      ['Chorizo de bilbao', 'Garlic', 'Vinegar'],
      65,
      category: MealCategory.meat,
    ),
    _Meal(
      'Embutido',
      ['Ground pork', 'Egg', 'Pickles', 'Raisins'],
      55,
      category: MealCategory.meat,
    ),
    _Meal(
      'Meatloaf',
      ['Ground pork', 'Carrot', 'Peas', 'Egg'],
      50,
      category: MealCategory.meat,
    ),
    _Meal(
      'Hamonado',
      ['Pork', 'Pineapple juice', 'Brown sugar', 'Soy sauce'],
      88,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chicken Hamonado',
      ['Chicken', 'Pineapple juice', 'Brown sugar', 'Soy sauce'],
      82,
      category: MealCategory.meat,
    ),
    _Meal(
      'Morcon',
      ['Beef', 'Sausage', 'Egg', 'Pickles'],
      110,
      category: MealCategory.meat,
    ),
    _Meal(
      'Beef Tapa Flakes',
      ['Beef', 'Soy sauce', 'Garlic', 'Sugar'],
      75,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Floss',
      ['Pork', 'Soy sauce', 'Sugar'],
      65,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Liempo',
      ['Pork belly', 'Salt', 'Pepper'],
      90,
      category: MealCategory.meat,
    ),
    _Meal(
      'Inihaw na Liempo',
      ['Pork belly', 'Soy sauce', 'Calamansi', 'Garlic'],
      95,
      category: MealCategory.meat,
    ),

    // VEGETABLE DISHES (50)
    _Meal(
      'Ginisang Monggo',
      ['Monggo beans', 'Pork bits', 'Malunggay', 'Garlic'],
      45,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Monggo with Tofu',
      ['Monggo beans', 'Tofu', 'Malunggay', 'Garlic'],
      40,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Pinakbet',
      ['Kalabasa', 'Sitaw', 'Ampalaya', 'Bagoong'],
      50,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Pinakbet Ilocano',
      ['Kalabasa', 'Sitaw', 'Ampalaya', 'Bagnet'],
      70,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Repolyo',
      ['Cabbage', 'Pork bits', 'Garlic', 'Soy sauce'],
      40,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Repolyo with Tofu',
      ['Cabbage', 'Tofu', 'Garlic', 'Soy sauce'],
      35,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Tortang Talong',
      ['Eggplant', '2 eggs', 'Garlic', 'Oil'],
      35,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Tortang Talong with Giniling',
      ['Eggplant', 'Ground pork', 'Egg'],
      50,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Toge',
      ['Bean sprouts', 'Tofu', 'Garlic', 'Soy sauce'],
      30,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginisang Toge with Tausi',
      ['Bean sprouts', 'Tofu', 'Black beans', 'Garlic'],
      32,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Ampalaya',
      ['Ampalaya', 'Egg', 'Garlic', 'Tomato'],
      35,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Ampalaya with Tofu',
      ['Ampalaya', 'Tofu', 'Egg', 'Garlic'],
      38,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Sitaw',
      ['String beans', 'Pork bits', 'Garlic', 'Bagoong'],
      40,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Sitaw with Tofu',
      ['String beans', 'Tofu', 'Garlic', 'Soy sauce'],
      35,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginisang Kangkong',
      ['Kangkong', 'Garlic', 'Bagoong', 'Oil'],
      25,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Kangkong with Tofu',
      ['Kangkong', 'Tofu', 'Garlic', 'Bagoong'],
      30,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Laing',
      ['Gabi leaves', 'Coconut milk', 'Chili', 'Shrimp paste'],
      55,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Laing with Pork',
      ['Gabi leaves', 'Coconut milk', 'Pork', 'Chili'],
      70,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ensaladang Talong',
      ['Eggplant', 'Tomato', 'Onion', 'Vinegar'],
      25,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ensaladang Mangga',
      ['Green mango', 'Tomato', 'Onion', 'Bagoong'],
      20,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Chop Suey',
      ['Cabbage', 'Carrot', 'Cauliflower', 'Pork'],
      60,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Chop Suey (Vegetarian)',
      ['Cabbage', 'Carrot', 'Cauliflower', 'Broccoli'],
      55,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Dinengdeng',
      ['Mixed vegetables', 'Fish', 'Bagoong'],
      45,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Dinengdeng with Fried Fish',
      ['Mixed vegetables', 'Fried fish', 'Bagoong'],
      55,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Bulanglang',
      ['Kalabasa', 'Sitaw', 'Okra', 'Bagoong'],
      40,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginataang Kalabasa',
      ['Kalabasa', 'Sitaw', 'Coconut milk', 'Garlic'],
      45,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginataang Kalabasa with Shrimp',
      ['Kalabasa', 'Sitaw', 'Coconut milk', 'Shrimp'],
      65,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginataang Langka',
      ['Jackfruit', 'Coconut milk', 'Shrimp paste', 'Chili'],
      50,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginataang Langka with Pork',
      ['Jackfruit', 'Coconut milk', 'Pork', 'Chili'],
      70,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginataang Kamoteng Kahoy',
      ['Cassava', 'Coconut milk', 'Fish'],
      40,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginataang Gulay',
      ['Mixed vegetables', 'Coconut milk', 'Garlic'],
      45,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginataang Puso ng Saging',
      ['Banana blossom', 'Coconut milk', 'Pork'],
      60,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginataang Puso ng Saging with Tofu',
      ['Banana blossom', 'Coconut milk', 'Tofu'],
      50,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Adobong Kangkong',
      ['Kangkong', 'Soy sauce', 'Vinegar', 'Garlic'],
      25,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Adobong Sitaw',
      ['String beans', 'Soy sauce', 'Vinegar', 'Garlic'],
      30,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Adobong Talong',
      ['Eggplant', 'Soy sauce', 'Vinegar', 'Garlic'],
      28,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Adobong Kangkong with Tofu',
      ['Kangkong', 'Tofu', 'Soy sauce', 'Vinegar'],
      35,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginisang Upo',
      ['Bottle gourd', 'Shrimp', 'Garlic', 'Soy sauce'],
      40,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Upo with Tofu',
      ['Bottle gourd', 'Tofu', 'Garlic', 'Soy sauce'],
      35,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginisang Patola',
      ['Patola', 'Shrimp', 'Garlic', 'Soy sauce'],
      38,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Patola with Tofu',
      ['Patola', 'Tofu', 'Garlic', 'Soy sauce'],
      32,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginisang Sayote',
      ['Sayote', 'Pork bits', 'Garlic', 'Soy sauce'],
      38,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Sayote with Tofu',
      ['Sayote', 'Tofu', 'Garlic', 'Soy sauce'],
      32,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginisang Pechay',
      ['Pechay', 'Pork bits', 'Garlic', 'Fish sauce'],
      35,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Pechay with Tofu',
      ['Pechay', 'Tofu', 'Garlic', 'Soy sauce'],
      30,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginisang Togue',
      ['Mung bean sprouts', 'Tofu', 'Garlic', 'Soy sauce'],
      30,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginisang Togue with Shrimp',
      ['Mung bean sprouts', 'Shrimp', 'Garlic', 'Soy sauce'],
      45,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Okra',
      ['Okra', 'Pork bits', 'Garlic', 'Fish sauce'],
      35,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Okra with Tofu',
      ['Okra', 'Tofu', 'Garlic', 'Soy sauce'],
      32,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginisang Kalabasa',
      ['Kalabasa', 'Pork bits', 'Garlic', 'Fish sauce'],
      45,
      category: MealCategory.vegetables,
    ),

    // SEAFOOD DISHES (50)
    _Meal(
      'Paksiw na Isda',
      ['Fish', 'Vinegar', 'Ginger', 'Garlic'],
      55,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Paksiw na Bangus',
      ['Bangus', 'Vinegar', 'Ginger', 'Garlic'],
      60,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Sinigang na Isda',
      ['Fish', 'Kangkong', 'Tomato', 'Sampalok mix'],
      65,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Sinigang na Bangus',
      ['Bangus', 'Kangkong', 'Tomato', 'Sampalok'],
      70,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Sinigang na Hipon',
      ['Shrimp', 'Kangkong', 'Tomato', 'Sampalok mix'],
      75,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Daing na Bangus',
      ['Bangus', 'Vinegar', 'Garlic', 'Oil'],
      60,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Daing na Labahita',
      ['Surgeonfish', 'Vinegar', 'Garlic', 'Oil'],
      65,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Grilled Tilapia',
      ['Tilapia', 'Salt', 'Pepper', 'Calamansi'],
      65,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Grilled Bangus',
      ['Bangus', 'Tomato', 'Onion', 'Salt'],
      70,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Grilled Pusit',
      ['Squid', 'Soy sauce', 'Calamansi', 'Oil'],
      70,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Adobong Pusit',
      ['Squid', 'Soy sauce', 'Vinegar', 'Garlic'],
      70,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Adobong Hito',
      ['Catfish', 'Soy sauce', 'Vinegar', 'Garlic'],
      65,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Fried Bangus',
      ['Bangus', 'Salt', 'Oil'],
      58,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Fried Tilapia',
      ['Tilapia', 'Salt', 'Oil'],
      55,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Fried Galunggong',
      ['Mackerel', 'Salt', 'Oil'],
      50,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Relyenong Bangus',
      ['Bangus', 'Tomato', 'Onion', 'Bread crumbs'],
      85,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Relyenong Pusit',
      ['Squid', 'Ground pork', 'Tomato', 'Onion'],
      80,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Escabeche',
      ['Fish', 'Sweet sauce', 'Ginger', 'Onion'],
      75,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Sweet and Sour Fish',
      ['Fish fillet', 'Bell pepper', 'Pineapple', 'Sweet sauce'],
      80,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Ginataang Alimango',
      ['Crab', 'Coconut milk', 'Ginger', 'Chili'],
      120,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Ginataang Alimasag',
      ['Crab', 'Coconut milk', 'Kalabasa', 'Sitaw'],
      110,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Ginataang Hipon',
      ['Shrimp', 'Coconut milk', 'Kalabasa', 'Sitaw'],
      85,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Ginataang Tulingan',
      ['Tuna', 'Coconut milk', 'Ginger', 'Chili'],
      80,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Ginataang Isda',
      ['Fish', 'Coconut milk', 'Ginger', 'Chili'],
      75,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Ginataang Sugpo',
      ['Prawns', 'Coconut milk', 'Kalabasa', 'Sitaw'],
      130,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Sugpo sa Gata',
      ['Prawns', 'Coconut milk', 'Chili', 'Garlic'],
      125,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Halabos na Hipon',
      ['Shrimp', 'Calamansi', 'Garlic', 'Salt'],
      70,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Halabos na Sugpo',
      ['Prawns', 'Calamansi', 'Garlic', 'Salt'],
      100,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Inihaw na Tuna',
      ['Tuna belly', 'Soy sauce', 'Calamansi', 'Garlic'],
      95,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Inihaw na Tanigue',
      ['Tanigue', 'Salt', 'Pepper', 'Oil'],
      85,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Inihaw na Pusit',
      ['Squid', 'Soy sauce', 'Calamansi', 'Oil'],
      70,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Baked Salmon',
      ['Salmon', 'Butter', 'Garlic', 'Lemon'],
      120,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Baked Tuna',
      ['Tuna', 'Mayonnaise', 'Garlic', 'Onion'],
      90,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Tuna Sisig',
      ['Tuna', 'Onion', 'Chili', 'Mayonnaise'],
      85,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Pusit Sisig',
      ['Squid', 'Onion', 'Chili', 'Calamansi'],
      75,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Kinilaw na Tuna',
      ['Fresh tuna', 'Vinegar', 'Ginger', 'Onion'],
      80,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Kinilaw na Tanigue',
      ['Tanigue', 'Vinegar', 'Ginger', 'Onion'],
      85,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Kinilaw na Isda',
      ['Fish', 'Vinegar', 'Ginger', 'Onion'],
      70,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Kinilaw na Pusit',
      ['Squid', 'Vinegar', 'Ginger', 'Onion'],
      65,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Kinilaw na Hipon',
      ['Shrimp', 'Vinegar', 'Ginger', 'Onion'],
      75,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Sinuglaw',
      ['Grilled pork', 'Kinilaw na tuna', 'Onion', 'Cucumber'],
      90,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Sarsiado',
      ['Fish', 'Egg', 'Tomato', 'Onion'],
      65,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Fish Fillet with Cream',
      ['Fish fillet', 'Cream', 'Mushroom', 'Garlic'],
      85,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Breaded Fish Fillet',
      ['Fish fillet', 'Bread crumbs', 'Egg', 'Flour'],
      70,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Fish and Chips',
      ['Fish fillet', 'Potato fries', 'Tartar sauce'],
      80,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Pritong Alimango',
      ['Crab', 'Garlic', 'Salt', 'Oil'],
      100,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Pritong Alimasag',
      ['Crab', 'Garlic', 'Salt', 'Oil'],
      90,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Pritong Hipon',
      ['Shrimp', 'Garlic', 'Salt', 'Oil'],
      65,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Pritong Dilis',
      ['Anchovies', 'Garlic', 'Salt', 'Oil'],
      40,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Pritong Hito',
      ['Catfish', 'Garlic', 'Salt', 'Oil'],
      60,
      category: MealCategory.seafood,
    ),

    // RICE DISHES (50)
    _Meal(
      'Sinangag',
      ['Garlic', 'Rice', 'Salt'],
      10,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Garlic Fried Rice',
      ['Rice', 'Garlic', 'Salt', 'Oil'],
      12,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Java Rice',
      ['Rice', 'Annatto', 'Garlic', 'Butter'],
      15,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Paella',
      ['Rice', 'Chicken', 'Shrimp', 'Saffron'],
      120,
      category: MealCategory.rice,
    ),
    _Meal(
      'Arroz Valenciana',
      ['Rice', 'Chicken', 'Pork', 'Bell pepper'],
      100,
      category: MealCategory.rice,
    ),
    _Meal(
      'Arroz Caldo',
      ['Rice', 'Chicken', 'Ginger', 'Garlic'],
      35,
      category: MealCategory.rice,
    ),
    _Meal(
      'Goto',
      ['Rice', 'Beef tripe', 'Ginger', 'Garlic'],
      40,
      category: MealCategory.rice,
    ),
    _Meal(
      'Lugaw',
      ['Rice', 'Ginger', 'Garlic', 'Salt'],
      12,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Champorado',
      ['Malagkit rice', 'Cocoa powder', 'Sugar', 'Milk'],
      20,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Biko',
      ['Malagkit rice', 'Brown sugar', 'Coconut milk'],
      25,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Bibingka',
      ['Rice flour', 'Coconut milk', 'Egg', 'Sugar'],
      20,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Puto',
      ['Rice flour', 'Sugar', 'Water', 'Yeast'],
      10,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Kutsinta',
      ['Rice flour', 'Brown sugar', 'Lye water'],
      10,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Suman',
      ['Malagkit rice', 'Coconut milk', 'Salt'],
      15,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Suman sa Lihiya',
      ['Malagkit rice', 'Lye water', 'Coconut milk'],
      15,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Palitaw',
      ['Rice flour', 'Coconut', 'Sugar', 'Sesame'],
      15,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Puto Bumbong',
      ['Purple rice', 'Grated coconut', 'Sugar'],
      25,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Cuchinta',
      ['Rice flour', 'Brown sugar', 'Lye water'],
      10,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Tupig',
      ['Malagkit rice', 'Coconut', 'Sugar', 'Banana leaf'],
      20,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Puto Calasiao',
      ['Rice flour', 'Sugar', 'Yeast'],
      8,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Puto Lanson',
      ['Rice flour', 'Sugar', 'Coconut milk'],
      12,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Puto Maya',
      ['Malagkit rice', 'Ginger', 'Coconut milk'],
      18,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Puto Seko',
      ['Rice flour', 'Sugar', 'Butter'],
      10,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Moron',
      ['Malagkit rice', 'Cocoa', 'Coconut milk'],
      20,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Inutak',
      ['Malagkit rice', 'Coconut milk', 'Sugar'],
      25,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Kalamay',
      ['Malagkit rice', 'Brown sugar', 'Coconut milk'],
      20,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Kalamay-Hati',
      ['Malagkit rice', 'Coconut milk', 'Sugar'],
      18,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Espasol',
      ['Rice flour', 'Coconut milk', 'Sugar'],
      15,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Pichi-pichi',
      ['Cassava', 'Sugar', 'Lye water', 'Grated coconut'],
      12,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Cassava Cake',
      ['Cassava', 'Coconut milk', 'Condensed milk'],
      35,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Maja Blanca',
      ['Cornstarch', 'Coconut milk', 'Corn kernels'],
      30,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Nilupak',
      ['Cassava', 'Coconut', 'Sugar', 'Butter'],
      25,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Baye-baye',
      ['Malagkit rice', 'Coconut', 'Sugar'],
      20,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Sapin-sapin',
      ['Rice flour', 'Coconut milk', 'Purple yam'],
      20,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Tikoy',
      ['Glutinous rice flour', 'Sugar', 'Water'],
      25,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Sinukmani',
      ['Malagkit rice', 'Coconut milk', 'Sugar'],
      20,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Biko with Latik',
      ['Malagkit rice', 'Brown sugar', 'Coconut curds'],
      28,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Bibingka Galapong',
      ['Rice flour', 'Coconut milk', 'Egg', 'Cheese'],
      30,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Bibingka Espesyal',
      ['Rice flour', 'Coconut milk', 'Egg', 'Salted egg'],
      35,
      category: MealCategory.rice,
    ),
    _Meal(
      'Bibingka sa Hurno',
      ['Rice flour', 'Coconut milk', 'Butter', 'Cheese'],
      40,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Puto Flan',
      ['Rice flour', 'Leche flan', 'Cheese'],
      25,
      category: MealCategory.rice,
    ),
    _Meal(
      'Puto Cheese',
      ['Rice flour', 'Cheese', 'Sugar'],
      15,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Puto Ube',
      ['Rice flour', 'Ube halaya', 'Sugar'],
      18,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Puto Pao',
      ['Rice flour', 'Asado filling', 'Salted egg'],
      25,
      category: MealCategory.rice,
    ),
    _Meal(
      'Siopao Asado',
      ['Flour', 'Pork asado', 'Sauce'],
      30,
      category: MealCategory.rice,
    ),
    _Meal(
      'Siopao Bola-bola',
      ['Flour', 'Ground pork', 'Salted egg'],
      28,
      category: MealCategory.rice,
    ),
    _Meal(
      'Siomai Rice',
      ['Siomai', 'Rice', 'Soy sauce', 'Calamansi'],
      40,
      category: MealCategory.rice,
    ),
    _Meal(
      'Lumpiang Shanghai Rice',
      ['Lumpia', 'Rice', 'Sweet sauce'],
      45,
      category: MealCategory.rice,
    ),
    _Meal(
      'Tapsi',
      ['Tapa', 'Sinangag', 'Egg'],
      60,
      category: MealCategory.rice,
    ),
    _Meal(
      'Fried Rice with Egg',
      ['Rice', 'Egg', 'Garlic', 'Soy sauce'],
      25,
      category: MealCategory.rice,
    ),

    // NOODLES DISHES (50)
    _Meal(
      'Pancit Canton',
      ['Noodles', 'Chicken', 'Vegetables', 'Soy sauce'],
      65,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Canton Guisado',
      ['Canton noodles', 'Pork', 'Shrimp', 'Vegetables'],
      75,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Bihon',
      ['Rice noodles', 'Pork', 'Vegetables', 'Calabasa'],
      60,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Bihon Guisado',
      ['Rice noodles', 'Chicken', 'Shrimp', 'Vegetables'],
      70,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Malabon',
      ['Thick noodles', 'Shrimp', 'Pork', 'Vegetables'],
      80,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Palabok',
      ['Rice noodles', 'Shrimp sauce', 'Pork', 'Egg'],
      75,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Sotanghon',
      ['Bean thread', 'Chicken', 'Vegetables', 'Garlic'],
      55,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Sotanghon with Shrimp',
      ['Bean thread', 'Shrimp', 'Vegetables', 'Garlic'],
      70,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Sotanghon with Pork',
      ['Bean thread', 'Pork', 'Vegetables', 'Garlic'],
      60,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Spaghetti',
      ['Spaghetti pasta', 'Tomato sauce', 'Ground pork', 'Hotdog'],
      70,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Filipino Spaghetti',
      ['Spaghetti', 'Sweet sauce', 'Ground pork', 'Hotdog'],
      75,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Carbonara',
      ['Pasta', 'Cream', 'Bacon', 'Mushroom'],
      85,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Chicken Noodles',
      ['Egg noodles', 'Chicken', 'Broth', 'Veggies'],
      55,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Beef Noodles',
      ['Egg noodles', 'Beef', 'Broth', 'Veggies'],
      65,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pork Noodles',
      ['Egg noodles', 'Pork', 'Broth', 'Veggies'],
      60,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Mami',
      ['Egg noodles', 'Chicken', 'Broth', 'Chicharon'],
      45,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Beef Mami',
      ['Egg noodles', 'Beef', 'Broth', 'Chicharon'],
      55,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pork Mami',
      ['Egg noodles', 'Pork', 'Broth', 'Chicharon'],
      50,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Lomi',
      ['Thick egg noodles', 'Pork', 'Liver', 'Broth'],
      60,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Lomi with Egg',
      ['Thick egg noodles', 'Pork', 'Liver', 'Egg'],
      65,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Chicken Lomi',
      ['Thick egg noodles', 'Chicken', 'Broth', 'Egg'],
      58,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Batchoy',
      ['Egg noodles', 'Pork', 'Liver', 'Broth'],
      55,
      category: MealCategory.noodles,
    ),
    _Meal(
      'La Paz Batchoy',
      ['Egg noodles', 'Pork', 'Liver', 'Crushed chicharon'],
      65,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Chow Mein',
      ['Egg noodles', 'Chicken', 'Vegetables', 'Soy sauce'],
      70,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Beef Chow Mein',
      ['Egg noodles', 'Beef', 'Vegetables', 'Soy sauce'],
      75,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Shrimp Chow Mein',
      ['Egg noodles', 'Shrimp', 'Vegetables', 'Soy sauce'],
      80,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Lo Mein',
      ['Egg noodles', 'Pork', 'Vegetables', 'Soy sauce'],
      68,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pad Thai',
      ['Rice noodles', 'Shrimp', 'Tofu', 'Peanuts'],
      85,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pad Thai with Chicken',
      ['Rice noodles', 'Chicken', 'Tofu', 'Peanuts'],
      80,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Japchae',
      ['Sweet potato noodles', 'Beef', 'Vegetables', 'Sesame'],
      90,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Molo',
      ['Wonton wrappers', 'Ground pork', 'Broth', 'Green onions'],
      60,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Molo with Shrimp',
      ['Wonton wrappers', 'Pork', 'Shrimp', 'Broth'],
      75,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Marilao',
      ['Thick noodles', 'Pork', 'Shrimp', 'Sauce'],
      85,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Luglug',
      ['Rice noodles', 'Shrimp sauce', 'Pork', 'Egg'],
      70,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Cabagan',
      ['Fresh noodles', 'Pork', 'Vegetables', 'Sauce'],
      80,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Habhab',
      ['Rice noodles', 'Pork', 'Vegetables', 'Sauce'],
      55,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Lucban',
      ['Rice noodles', 'Pork', 'Shrimp', 'Sauce'],
      75,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Batil Patung',
      ['Egg noodles', 'Beef', 'Egg', 'Vegetables'],
      90,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Tuguegarao',
      ['Fresh noodles', 'Pork', 'Vegetables', 'Sauce'],
      85,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Sopa de Fideo',
      ['Vermicelli', 'Chicken', 'Tomato', 'Vegetables'],
      50,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Sopa de Pollo',
      ['Vermicelli', 'Chicken', 'Broth', 'Vegetables'],
      48,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Misua with Patola',
      ['Misua', 'Patola', 'Shrimp', 'Garlic'],
      45,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Misua with Meatballs',
      ['Misua', 'Meatballs', 'Garlic', 'Broth'],
      50,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Misua with Togue',
      ['Misua', 'Bean sprouts', 'Garlic', 'Soy sauce'],
      35,
      category: MealCategory.noodles,
      isVegetarian: true,
    ),
    _Meal(
      'Misua with Sardines',
      ['Misua', 'Sardines', 'Garlic', 'Onion'],
      40,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Misua with Pork',
      ['Misua', 'Ground pork', 'Garlic', 'Broth'],
      45,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Odong',
      ['Odong noodles', 'Sardines', 'Vegetables', 'Broth'],
      40,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Odong with Shrimp',
      ['Odong noodles', 'Shrimp', 'Vegetables', 'Broth'],
      60,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Odong with Pork',
      ['Odong noodles', 'Pork', 'Vegetables', 'Broth'],
      50,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Estacion',
      ['Noodles', 'Shrimp', 'Pork', 'Sauce'],
      95,
      category: MealCategory.noodles,
    ),

    // SOUP DISHES (50)
    _Meal(
      'Sinigang na Baboy',
      ['Pork', 'Kangkong', 'Tomato', 'Sampalok mix'],
      80,
      category: MealCategory.soup,
    ),
    _Meal(
      'Sinigang na Baka',
      ['Beef', 'Kangkong', 'Tomato', 'Sampalok mix'],
      90,
      category: MealCategory.soup,
    ),
    _Meal(
      'Sinigang na Manok',
      ['Chicken', 'Kangkong', 'Tomato', 'Sampalok mix'],
      75,
      category: MealCategory.soup,
    ),
    _Meal(
      'Sinigang na Hipon',
      ['Shrimp', 'Kangkong', 'Tomato', 'Sampalok mix'],
      80,
      category: MealCategory.soup,
    ),
    _Meal(
      'Sinigang na Isda',
      ['Fish', 'Kangkong', 'Tomato', 'Sampalok mix'],
      70,
      category: MealCategory.soup,
    ),
    _Meal(
      'Sinigang na Salmon',
      ['Salmon', 'Kangkong', 'Tomato', 'Sampalok mix'],
      95,
      category: MealCategory.soup,
    ),
    _Meal(
      'Sinigang na Bangus',
      ['Bangus', 'Kangkong', 'Tomato', 'Sampalok'],
      75,
      category: MealCategory.soup,
    ),
    _Meal(
      'Nilagang Baka',
      ['Beef', 'Pechay', 'Potato', 'Onion'],
      90,
      category: MealCategory.soup,
    ),
    _Meal(
      'Nilagang Baboy',
      ['Pork', 'Pechay', 'Potato', 'Onion'],
      80,
      category: MealCategory.soup,
    ),
    _Meal(
      'Nilagang Manok',
      ['Chicken', 'Pechay', 'Potato', 'Onion'],
      75,
      category: MealCategory.soup,
    ),
    _Meal(
      'Bulalo',
      ['Beef shank', 'Corn', 'Pechay', 'Onion'],
      120,
      category: MealCategory.soup,
    ),
    _Meal(
      'Bulalo with Bone Marrow',
      ['Beef shank', 'Bone marrow', 'Corn', 'Pechay'],
      150,
      category: MealCategory.soup,
    ),
    _Meal(
      'Tinolang Manok',
      ['Chicken', 'Sayote', 'Malunggay', 'Ginger'],
      75,
      category: MealCategory.soup,
    ),
    _Meal(
      'Tinolang Manok with Papaya',
      ['Chicken', 'Papaya', 'Malunggay', 'Ginger'],
      70,
      category: MealCategory.soup,
    ),
    _Meal(
      'Tinolang Isda',
      ['Fish', 'Sayote', 'Malunggay', 'Ginger'],
      65,
      category: MealCategory.soup,
    ),
    _Meal(
      'Binakol',
      ['Chicken', 'Coconut water', 'Ginger', 'Lemongrass'],
      85,
      category: MealCategory.soup,
    ),
    _Meal(
      'Binakol na Manok',
      ['Chicken', 'Coconut water', 'Sayote', 'Ginger'],
      90,
      category: MealCategory.soup,
    ),
    _Meal(
      'Ginataang Manok',
      ['Chicken', 'Coconut milk', 'Ginger', 'Chili'],
      85,
      category: MealCategory.soup,
    ),
    _Meal(
      'Ginataang Isda',
      ['Fish', 'Coconut milk', 'Ginger', 'Chili'],
      80,
      category: MealCategory.soup,
    ),
    _Meal(
      'Ginataang Hipon',
      ['Shrimp', 'Coconut milk', 'Kalabasa', 'Sitaw'],
      85,
      category: MealCategory.soup,
    ),
    _Meal(
      'Molo Soup',
      ['Pork dumplings', 'Broth', 'Green onions', 'Garlic'],
      65,
      category: MealCategory.soup,
    ),
    _Meal(
      'Molo Soup with Shrimp',
      ['Shrimp dumplings', 'Broth', 'Green onions', 'Garlic'],
      80,
      category: MealCategory.soup,
    ),
    _Meal(
      'Corn Soup',
      ['Corn', 'Chicken broth', 'Egg', 'Green onions'],
      40,
      category: MealCategory.soup,
    ),
    _Meal(
      'Corn Soup with Crab',
      ['Corn', 'Crab meat', 'Egg', 'Broth'],
      75,
      category: MealCategory.soup,
    ),
    _Meal(
      'Mushroom Soup',
      ['Mushroom', 'Cream', 'Garlic', 'Onion'],
      50,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Cream of Mushroom',
      ['Mushroom', 'Cream', 'Butter', 'Flour'],
      55,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Cream of Broccoli',
      ['Broccoli', 'Cream', 'Onion', 'Garlic'],
      60,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Cream of Asparagus',
      ['Asparagus', 'Cream', 'Onion', 'Butter'],
      65,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Tomato Soup',
      ['Tomato', 'Garlic', 'Onion', 'Basil'],
      35,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Vegetable Soup',
      ['Mixed vegetables', 'Broth', 'Garlic', 'Onion'],
      40,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Chicken Soup',
      ['Chicken', 'Vegetables', 'Broth', 'Garlic'],
      55,
      category: MealCategory.soup,
    ),
    _Meal(
      'Chicken Noodle Soup',
      ['Chicken', 'Egg noodles', 'Broth', 'Vegetables'],
      60,
      category: MealCategory.soup,
    ),
    _Meal(
      'Beef Soup',
      ['Beef', 'Vegetables', 'Broth', 'Garlic'],
      70,
      category: MealCategory.soup,
    ),
    _Meal(
      'Beef Noodle Soup',
      ['Beef', 'Egg noodles', 'Broth', 'Vegetables'],
      75,
      category: MealCategory.soup,
    ),
    _Meal(
      'Pork Soup',
      ['Pork', 'Vegetables', 'Broth', 'Garlic'],
      65,
      category: MealCategory.soup,
    ),
    _Meal(
      'Pork Noodle Soup',
      ['Pork', 'Egg noodles', 'Broth', 'Vegetables'],
      70,
      category: MealCategory.soup,
    ),
    _Meal(
      'Seafood Soup',
      ['Shrimp', 'Squid', 'Fish', 'Vegetables'],
      85,
      category: MealCategory.soup,
    ),
    _Meal(
      'Seafood Noodle Soup',
      ['Shrimp', 'Squid', 'Noodles', 'Broth'],
      90,
      category: MealCategory.soup,
    ),
    _Meal(
      'Fish Soup',
      ['Fish', 'Vegetables', 'Broth', 'Ginger'],
      60,
      category: MealCategory.soup,
    ),
    _Meal(
      'Fish Noodle Soup',
      ['Fish', 'Noodles', 'Broth', 'Ginger'],
      65,
      category: MealCategory.soup,
    ),
    _Meal(
      'Shrimp Soup',
      ['Shrimp', 'Vegetables', 'Broth', 'Garlic'],
      70,
      category: MealCategory.soup,
    ),
    _Meal(
      'Shrimp Noodle Soup',
      ['Shrimp', 'Noodles', 'Broth', 'Garlic'],
      75,
      category: MealCategory.soup,
    ),
    _Meal(
      'Lentil Soup',
      ['Lentils', 'Carrot', 'Onion', 'Garlic'],
      45,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Bean Soup',
      ['Beans', 'Pork', 'Vegetables', 'Broth'],
      50,
      category: MealCategory.soup,
    ),
    _Meal(
      'Pumpkin Soup',
      ['Kalabasa', 'Cream', 'Onion', 'Garlic'],
      55,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Carrot Soup',
      ['Carrot', 'Ginger', 'Onion', 'Cream'],
      40,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Potato Soup',
      ['Potato', 'Cream', 'Onion', 'Garlic'],
      45,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Cabbage Soup',
      ['Cabbage', 'Carrot', 'Tomato', 'Onion'],
      35,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Egg Drop Soup',
      ['Egg', 'Broth', 'Green onions', 'Cornstarch'],
      30,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Hot and Sour Soup',
      ['Mushroom', 'Tofu', 'Egg', 'Vinegar'],
      50,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
  ];

  // ---------- DINNERS (same as lunches but can have unique ones) ----------
  static const List<_Meal> dinners = [
    // Meat
    _Meal(
      'Adobong Baboy',
      ['Pork', 'Soy sauce', 'Vinegar', 'Bay leaf'],
      75,
      category: MealCategory.meat,
    ),
    _Meal(
      'Adobong Manok',
      ['Chicken', 'Soy sauce', 'Vinegar', 'Garlic'],
      70,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Steak',
      ['Pork', 'Soy sauce', 'Calamansi', 'Onion'],
      72,
      category: MealCategory.meat,
    ),
    _Meal(
      'Beef Steak',
      ['Beef', 'Soy sauce', 'Calamansi', 'Onion'],
      95,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chicken Curry',
      ['Chicken', 'Coconut milk', 'Curry powder', 'Potato'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Curry',
      ['Pork', 'Coconut milk', 'Curry powder', 'Potato'],
      82,
      category: MealCategory.meat,
    ),
    _Meal(
      'Lechon Manok',
      ['Whole chicken', 'Lemongrass', 'Salt', 'Pepper'],
      150,
      category: MealCategory.meat,
    ),
    _Meal(
      'Liempo',
      ['Pork belly', 'Salt', 'Pepper', 'Oil'],
      90,
      category: MealCategory.meat,
    ),
    _Meal(
      'Bistek Tagalog',
      ['Beef', 'Soy sauce', 'Calamansi', 'Onion'],
      88,
      category: MealCategory.meat,
    ),
    _Meal(
      'Igado',
      ['Pork', 'Liver', 'Peas', 'Carrot'],
      78,
      category: MealCategory.meat,
    ),
    _Meal(
      'Dinuguan',
      ['Pork blood', 'Pork meat', 'Vinegar', 'Chili'],
      70,
      category: MealCategory.meat,
    ),
    _Meal(
      'Sisig',
      ['Pork face', 'Chicken liver', 'Onion', 'Calamansi'],
      90,
      category: MealCategory.meat,
    ),
    _Meal(
      'Lechon Kawali',
      ['Pork belly', 'Salt', 'Pepper', 'Oil'],
      95,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pata Tim',
      ['Pork leg', 'Soy sauce', 'Star anise', 'Brown sugar'],
      150,
      category: MealCategory.meat,
    ),
    _Meal(
      'Humba',
      ['Pork', 'Pineapple', 'Soy sauce', 'Vinegar'],
      82,
      category: MealCategory.meat,
    ),
    _Meal(
      'Menudo',
      ['Pork', 'Potato', 'Carrot', 'Tomato sauce'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Kaldereta',
      ['Beef', 'Tomato sauce', 'Potato', 'Carrot'],
      95,
      category: MealCategory.meat,
    ),
    _Meal(
      'Mechado',
      ['Beef', 'Tomato sauce', 'Potato', 'Soy sauce'],
      92,
      category: MealCategory.meat,
    ),
    _Meal(
      'Afritada',
      ['Chicken', 'Tomato sauce', 'Potato', 'Carrot'],
      78,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Afritada',
      ['Pork', 'Tomato sauce', 'Potato', 'Bell pepper'],
      80,
      category: MealCategory.meat,
    ),
    _Meal(
      'Bicol Express',
      ['Pork', 'Coconut milk', 'Shrimp paste', 'Chili'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chicken Adobo sa Gata',
      ['Chicken', 'Coconut milk', 'Soy sauce', 'Vinegar'],
      82,
      category: MealCategory.meat,
    ),
    _Meal(
      'Pork Adobo sa Gata',
      ['Pork', 'Coconut milk', 'Soy sauce', 'Vinegar'],
      85,
      category: MealCategory.meat,
    ),
    _Meal(
      'Chicken Pastel',
      ['Chicken', 'Cream', 'Mushroom', 'Bell pepper'],
      95,
      category: MealCategory.meat,
    ),
    _Meal(
      'Rellenong Manok',
      ['Whole chicken', 'Ground pork', 'Egg', 'Pickles'],
      120,
      category: MealCategory.meat,
    ),
    _Meal(
      'Embutido',
      ['Ground pork', 'Egg', 'Pickles', 'Raisins'],
      55,
      category: MealCategory.meat,
    ),
    _Meal(
      'Meatloaf',
      ['Ground pork', 'Carrot', 'Peas', 'Egg'],
      50,
      category: MealCategory.meat,
    ),
    _Meal(
      'Hamonado',
      ['Pork', 'Pineapple juice', 'Brown sugar', 'Soy sauce'],
      88,
      category: MealCategory.meat,
    ),
    _Meal(
      'Morcon',
      ['Beef', 'Sausage', 'Egg', 'Pickles'],
      110,
      category: MealCategory.meat,
    ),
    _Meal(
      'Inihaw na Liempo',
      ['Pork belly', 'Soy sauce', 'Calamansi', 'Garlic'],
      95,
      category: MealCategory.meat,
    ),
    // Vegetables
    _Meal(
      'Ginisang Ampalaya',
      ['Ampalaya', 'Egg', 'Garlic', 'Tomato'],
      35,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Pinakbet',
      ['Kalabasa', 'Sitaw', 'Ampalaya', 'Bagoong'],
      50,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Sitaw',
      ['String beans', 'Pork bits', 'Garlic', 'Bagoong'],
      40,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Laing',
      ['Gabi leaves', 'Coconut milk', 'Chili', 'Shrimp paste'],
      55,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Monggo',
      ['Monggo beans', 'Pork bits', 'Malunggay', 'Garlic'],
      45,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Repolyo',
      ['Cabbage', 'Pork bits', 'Garlic', 'Soy sauce'],
      40,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Tortang Talong',
      ['Eggplant', '2 eggs', 'Garlic', 'Oil'],
      35,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Chop Suey',
      ['Cabbage', 'Carrot', 'Cauliflower', 'Pork'],
      60,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginataang Kalabasa',
      ['Kalabasa', 'Sitaw', 'Coconut milk', 'Garlic'],
      45,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginataang Langka',
      ['Jackfruit', 'Coconut milk', 'Shrimp paste', 'Chili'],
      50,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Adobong Kangkong',
      ['Kangkong', 'Soy sauce', 'Vinegar', 'Garlic'],
      25,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    _Meal(
      'Ginisang Upo',
      ['Bottle gourd', 'Shrimp', 'Garlic', 'Soy sauce'],
      40,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Patola',
      ['Patola', 'Shrimp', 'Garlic', 'Soy sauce'],
      38,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Sayote',
      ['Sayote', 'Pork bits', 'Garlic', 'Soy sauce'],
      38,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Pechay',
      ['Pechay', 'Pork bits', 'Garlic', 'Fish sauce'],
      35,
      category: MealCategory.vegetables,
    ),
    _Meal(
      'Ginisang Togue',
      ['Mung bean sprouts', 'Tofu', 'Garlic', 'Soy sauce'],
      30,
      category: MealCategory.vegetables,
      isVegetarian: true,
    ),
    // Seafood
    _Meal(
      'Sinigang na Isda',
      ['Fish', 'Kangkong', 'Tomato', 'Sampalok mix'],
      65,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Grilled Tanigue',
      ['Tanigue', 'Salt', 'Pepper', 'Oil'],
      75,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Inihaw na Pusit',
      ['Squid', 'Soy sauce', 'Calamansi', 'Oil'],
      70,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Ginataang Tulingan',
      ['Tuna', 'Coconut milk', 'Ginger', 'Chili'],
      80,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Baked Salmon',
      ['Salmon', 'Butter', 'Garlic', 'Lemon'],
      120,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Paksiw na Isda',
      ['Fish', 'Vinegar', 'Ginger', 'Garlic'],
      55,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Daing na Bangus',
      ['Bangus', 'Vinegar', 'Garlic', 'Oil'],
      60,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Adobong Pusit',
      ['Squid', 'Soy sauce', 'Vinegar', 'Garlic'],
      70,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Relyenong Bangus',
      ['Bangus', 'Tomato', 'Onion', 'Bread crumbs'],
      85,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Escabeche',
      ['Fish', 'Sweet sauce', 'Ginger', 'Onion'],
      75,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Kinilaw na Tuna',
      ['Fresh tuna', 'Vinegar', 'Ginger', 'Onion'],
      80,
      category: MealCategory.seafood,
    ),
    _Meal(
      'Halabos na Hipon',
      ['Shrimp', 'Calamansi', 'Garlic', 'Salt'],
      70,
      category: MealCategory.seafood,
    ),
    // Soup
    _Meal(
      'Bulalo',
      ['Beef shank', 'Corn', 'Pechay', 'Onion'],
      120,
      category: MealCategory.soup,
    ),
    _Meal(
      'Sinigang na Baboy',
      ['Pork', 'Kangkong', 'Tomato', 'Sampalok mix'],
      80,
      category: MealCategory.soup,
    ),
    _Meal(
      'Sinigang na Salmon',
      ['Salmon', 'Kangkong', 'Tomato', 'Sampalok mix'],
      95,
      category: MealCategory.soup,
    ),
    _Meal(
      'Molo Soup',
      ['Pork dumplings', 'Broth', 'Green onions', 'Garlic'],
      65,
      category: MealCategory.soup,
    ),
    _Meal(
      'Corn Soup',
      ['Corn', 'Chicken broth', 'Egg', 'Green onions'],
      40,
      category: MealCategory.soup,
    ),
    _Meal(
      'Tinolang Manok',
      ['Chicken', 'Sayote', 'Malunggay', 'Ginger'],
      75,
      category: MealCategory.soup,
    ),
    _Meal(
      'Nilagang Baka',
      ['Beef', 'Pechay', 'Potato', 'Onion'],
      90,
      category: MealCategory.soup,
    ),
    _Meal(
      'Vegetable Soup',
      ['Mixed vegetables', 'Broth', 'Garlic', 'Onion'],
      40,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Mushroom Soup',
      ['Mushroom', 'Cream', 'Garlic', 'Onion'],
      50,
      category: MealCategory.soup,
      isVegetarian: true,
    ),
    _Meal(
      'Seafood Soup',
      ['Shrimp', 'Squid', 'Fish', 'Vegetables'],
      85,
      category: MealCategory.soup,
    ),
    // Noodles
    _Meal(
      'Pancit Canton',
      ['Noodles', 'Chicken', 'Vegetables', 'Soy sauce'],
      65,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Bihon',
      ['Rice noodles', 'Pork', 'Vegetables', 'Calabasa'],
      60,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Spaghetti',
      ['Spaghetti pasta', 'Tomato sauce', 'Ground pork', 'Hotdog'],
      70,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Sotanghon',
      ['Bean thread', 'Chicken', 'Vegetables', 'Garlic'],
      55,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Lomi',
      ['Thick egg noodles', 'Pork', 'Liver', 'Broth'],
      60,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Batchoy',
      ['Egg noodles', 'Pork', 'Liver', 'Broth'],
      55,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Malabon',
      ['Thick noodles', 'Shrimp', 'Pork', 'Vegetables'],
      80,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Palabok',
      ['Rice noodles', 'Shrimp sauce', 'Pork', 'Egg'],
      75,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Chow Mein',
      ['Egg noodles', 'Chicken', 'Vegetables', 'Soy sauce'],
      70,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pad Thai',
      ['Rice noodles', 'Shrimp', 'Tofu', 'Peanuts'],
      85,
      category: MealCategory.noodles,
    ),
    // Rice
    _Meal(
      'Sinangag',
      ['Garlic', 'Rice', 'Salt'],
      10,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Java Rice',
      ['Rice', 'Annatto', 'Garlic', 'Butter'],
      15,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Arroz Caldo',
      ['Rice', 'Chicken', 'Ginger', 'Garlic'],
      35,
      category: MealCategory.rice,
    ),
    _Meal(
      'Goto',
      ['Rice', 'Beef tripe', 'Ginger', 'Garlic'],
      40,
      category: MealCategory.rice,
    ),
    _Meal(
      'Lugaw',
      ['Rice', 'Ginger', 'Garlic', 'Salt'],
      12,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Champorado',
      ['Malagkit rice', 'Cocoa powder', 'Sugar', 'Milk'],
      20,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Paella',
      ['Rice', 'Chicken', 'Shrimp', 'Saffron'],
      120,
      category: MealCategory.rice,
    ),
    _Meal(
      'Arroz Valenciana',
      ['Rice', 'Chicken', 'Pork', 'Bell pepper'],
      100,
      category: MealCategory.rice,
    ),
    _Meal(
      'Biko',
      ['Malagkit rice', 'Brown sugar', 'Coconut milk'],
      25,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Puto',
      ['Rice flour', 'Sugar', 'Water', 'Yeast'],
      10,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
  ];

  // ---------- SNACKS (50+ items) ----------
  static const List<_Meal> snacks = [
    // Fruits
    _Meal(
      'Saging na Saba',
      ['2 pcs saba banana'],
      10,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Mais',
      ['1 pc corn'],
      12,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Kamote',
      ['Boiled sweet potato'],
      10,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Mango',
      ['1 pc mango'],
      20,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Pinya',
      ['1 cup pineapple'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Pakwan',
      ['1 slice watermelon'],
      10,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Papaya',
      ['1 slice papaya'],
      10,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Apple',
      ['1 apple'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Orange',
      ['1 orange'],
      12,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Grapes',
      ['1 cup grapes'],
      25,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    // Breads
    _Meal(
      'Pandesal',
      ['2 pcs pandesal'],
      8,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Ensaymada',
      ['1 pc ensaymada'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Pan de Coco',
      ['1 pc pan de coco'],
      12,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Spanish Bread',
      ['2 pcs spanish bread'],
      18,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Kababayan',
      ['2 pcs kababayan'],
      10,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Cheese Bread',
      ['1 pc cheese bread'],
      12,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Ube Pandesal',
      ['2 pcs ube pandesal'],
      18,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Monay',
      ['1 pc monay'],
      8,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Toast with Jam',
      ['2 slices bread', 'Jam'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Bread with Butter',
      ['2 slices bread', 'Butter'],
      12,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    // Rice cakes
    _Meal(
      'Bibingka',
      ['1 slice bibingka', 'Grated coconut'],
      20,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Puto',
      ['2 pcs puto', 'Grated coconut'],
      10,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Kutsinta',
      ['2 pcs kutsinta', 'Grated coconut'],
      10,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Sapin-sapin',
      ['1 slice sapin-sapin', 'Latik'],
      20,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Palitaw',
      ['2 pcs palitaw', 'Sesame seeds', 'Sugar'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Suman',
      ['1 pc suman', 'Mango'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Puto Bumbong',
      ['1 pc puto bumbong', 'Grated coconut'],
      25,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Biko',
      ['1 slice biko', 'Latik'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Maja Blanca',
      ['1 slice maja blanca'],
      12,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Cassava Cake',
      ['1 slice cassava cake'],
      20,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    // Fried snacks
    _Meal(
      'Banana Cue',
      ['2 pcs saba', 'Brown sugar', 'Oil'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Camote Cue',
      ['2 pcs camote', 'Brown sugar', 'Oil'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Turon',
      ['Saba banana', 'Jackfruit', 'Sugar', 'Oil'],
      20,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Marian Pla',
      ['Marian pla', 'Oil'],
      10,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Lumpiang Shanghai',
      ['5 pcs lumpia', 'Sweet sauce'],
      25,
      category: MealCategory.all,
    ),
    _Meal(
      'Lumpiang Togue',
      ['5 pcs lumpiang togue', 'Vinegar'],
      20,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Lumpiang Ubod',
      ['1 pc lumpiang ubod', 'Peanut sauce'],
      30,
      category: MealCategory.all,
    ),
    _Meal(
      'Fishball',
      ['10 pcs fishball', 'Sauce'],
      15,
      category: MealCategory.all,
    ),
    _Meal('Kikiam', ['3 pcs kikiam', 'Sauce'], 15, category: MealCategory.all),
    _Meal(
      'Squidball',
      ['10 pcs squidball', 'Sauce'],
      18,
      category: MealCategory.all,
    ),
    _Meal(
      'Siomai',
      ['4 pcs siomai', 'Soy sauce', 'Calamansi'],
      30,
      category: MealCategory.all,
    ),
    _Meal('Siopao', ['1 pc siopao'], 25, category: MealCategory.all),
    _Meal(
      'Siopao Bola-bola',
      ['1 pc siopao bola-bola'],
      28,
      category: MealCategory.all,
    ),
    _Meal(
      'Siopao Asado',
      ['1 pc siopao asado'],
      30,
      category: MealCategory.all,
    ),
    // Beverages
    _Meal(
      'Biscuit + Kape',
      ['Biscuit pack', 'Instant coffee'],
      15,
      category: MealCategory.all,
    ),
    _Meal(
      'Milo + Biscuit',
      ['Milo', 'Biscuit'],
      20,
      category: MealCategory.all,
    ),
    _Meal(
      'Ginataan',
      ['Saba banana', 'Kamote', 'Coconut milk', 'Tapioca'],
      30,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Halo-halo',
      ['Shaved ice', 'Milk', 'Sweet beans', 'Leche flan'],
      35,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Mais con Yelo',
      ['Corn', 'Shaved ice', 'Milk', 'Sugar'],
      20,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      "Sago't Gulaman",
      ['Sago', 'Gulaman', 'Brown sugar'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Buko Juice',
      ['Buko', 'Sugar', 'Ice'],
      15,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Buko Pandan',
      ['Buko', 'Pandan', 'Cream', 'Sago'],
      25,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    _Meal(
      'Taho',
      ['Tofu', 'Sago', 'Syrup'],
      20,
      category: MealCategory.all,
      isVegetarian: true,
    ),
    // Light meals
    _Meal(
      'Lugaw',
      ['Rice', 'Ginger', 'Salt'],
      12,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Arroz Caldo',
      ['Rice', 'Chicken', 'Ginger', 'Garlic'],
      25,
      category: MealCategory.rice,
    ),
    _Meal(
      'Champorado',
      ['Malagkit rice', 'Cocoa', 'Sugar', 'Milk'],
      18,
      category: MealCategory.rice,
      isVegetarian: true,
    ),
    _Meal(
      'Pancit Canton',
      ['Noodles', 'Vegetables', 'Soy sauce'],
      25,
      category: MealCategory.noodles,
    ),
    _Meal(
      'Pancit Bihon',
      ['Rice noodles', 'Vegetables', 'Soy sauce'],
      22,
      category: MealCategory.noodles,
    ),
  ];

  static const List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  /// Picks a daily plan with variety in categories
  static _DayPlan pickDayPlan(
    double budget,
    int seed,
    String dayLabel, {
    MealCategory preferredCategory = MealCategory.all,
  }) {
    // Filter by category if specified
    List<_Meal> availableBreakfasts = preferredCategory == MealCategory.all
        ? breakfasts
        : breakfasts
              .where(
                (m) =>
                    m.category == preferredCategory ||
                    m.category == MealCategory.all,
              )
              .toList();

    List<_Meal> availableLunches = preferredCategory == MealCategory.all
        ? lunches
        : lunches.where((m) => m.category == preferredCategory).toList();

    List<_Meal> availableDinners = preferredCategory == MealCategory.all
        ? dinners
        : dinners.where((m) => m.category == preferredCategory).toList();

    List<_Meal> availableSnacks = preferredCategory == MealCategory.all
        ? snacks
        : snacks
              .where(
                (m) =>
                    m.category == preferredCategory ||
                    m.category == MealCategory.all,
              )
              .toList();

    // Ensure we have meals
    if (availableBreakfasts.isEmpty) availableBreakfasts = breakfasts;
    if (availableLunches.isEmpty) availableLunches = lunches;
    if (availableDinners.isEmpty) availableDinners = dinners;
    if (availableSnacks.isEmpty) availableSnacks = snacks;

    // Sort by cost
    final bs = [...availableBreakfasts]
      ..sort((a, b) => a.cost.compareTo(b.cost));
    final ls = [...availableLunches]..sort((a, b) => a.cost.compareTo(b.cost));
    final ds = [...availableDinners]..sort((a, b) => a.cost.compareTo(b.cost));
    final ss = [...availableSnacks]..sort((a, b) => a.cost.compareTo(b.cost));

    // Pick varied meals using seed offset
    int bIndex = seed % bs.length;
    int sIndex = (seed + 2) % ss.length;

    _Meal b = bs[bIndex];
    _Meal s = ss[sIndex];
    double remaining = budget - b.cost - s.cost;

    // Split remaining 60/40 between lunch and dinner
    double lunchBudget = remaining * 0.55;
    double dinnerBudget = remaining * 0.45;

    _Meal l = ls.lastWhere(
      (m) => m.cost <= lunchBudget,
      orElse: () => ls.first,
    );
    _Meal d = ds.lastWhere(
      (m) => m.cost <= dinnerBudget,
      orElse: () => ds.first,
    );

    // Try to avoid same dish for lunch and dinner
    if (l.name == d.name && ls.length > 1) {
      int lIndex = ls.indexOf(l);
      l = ls[(lIndex + 1) % ls.length];
    }

    return _DayPlan(dayLabel, b, l, d, s);
  }

  static List<_DayPlan> buildWeeklyPlan(
    double dailyBudget, {
    int seed = 0,
    MealCategory preferredCategory = MealCategory.all,
  }) {
    return List.generate(
      7,
      (i) => pickDayPlan(
        dailyBudget,
        i + seed + DateTime.now().day,
        _days[i],
        preferredCategory: preferredCategory,
      ),
    );
  }

  static _DayPlan buildDailyPlan(
    double budget, {
    int seed = 0,
    MealCategory preferredCategory = MealCategory.all,
  }) => pickDayPlan(
    budget,
    DateTime.now().hour + seed,
    'Today',
    preferredCategory: preferredCategory,
  );
}

// --- Screen ---

class AIAssistantScreen extends StatefulWidget {
  final double dailyBudget;
  const AIAssistantScreen({super.key, this.dailyBudget = 350.0});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  String _mode = 'Daily';
  MealCategory _selectedCategory = MealCategory.all;
  List<_DayPlan>? _plans;
  int _seed = 0;

  void _generate() {
    setState(() {
      if (_mode == 'Daily') {
        _plans = [
          _MealDB.buildDailyPlan(
            widget.dailyBudget,
            seed: _seed,
            preferredCategory: _selectedCategory,
          ),
        ];
      } else {
        _plans = _MealDB.buildWeeklyPlan(
          widget.dailyBudget,
          seed: _seed,
          preferredCategory: _selectedCategory,
        );
      }
    });
  }

  void _refreshPlan() {
    setState(() {
      _seed++;
      _generate();
    });
  }

  String _getCategoryName(MealCategory category) {
    switch (category) {
      case MealCategory.vegetables:
        return 'Vegetables';
      case MealCategory.meat:
        return 'Meat';
      case MealCategory.seafood:
        return 'Seafood';
      case MealCategory.rice:
        return 'Rice';
      case MealCategory.noodles:
        return 'Noodles';
      case MealCategory.soup:
        return 'Soup';
      case MealCategory.all:
        return 'All Categories';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeProvider>().mode;
    final bgCol = AppThemes.bg(mode);
    final cardCol = AppThemes.cardColor(mode);
    final accentCol = AppThemes.accent(mode);
    final textPri = AppThemes.textPrimary(mode);
    final textSec = AppThemes.textSecondary(mode);
    final shadows = AppThemes.shadow(mode);
    final borderCol = AppThemes.border(mode);
    final accentSub = AppThemes.accentSubtle(mode);

    final budget = _mode == 'Daily'
        ? widget.dailyBudget
        : widget.dailyBudget * 7;

    return Scaffold(
      backgroundColor: bgCol,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cardCol,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: borderCol == Colors.transparent
                              ? Colors.transparent
                              : borderCol,
                        ),
                        boxShadow: shadows,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: textPri,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Image.asset(
                    'assets/images/Baobuddylogo.png',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Baobuddy Assistant',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textPri,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Budget card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: accentCol,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: shadows,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.wallet,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$_mode Budget',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₱${budget.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Mode toggle
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: cardCol,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: borderCol == Colors.transparent
                              ? Colors.transparent
                              : borderCol,
                        ),
                        boxShadow: shadows,
                      ),
                      child: Row(
                        children: ['Daily', 'Weekly'].map((m) {
                          final selected = _mode == m;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _mode = m;
                                _plans = null;
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? accentCol
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  m,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selected ? Colors.white : textSec,
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Category filter
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: cardCol,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: borderCol == Colors.transparent
                              ? Colors.transparent
                              : borderCol,
                        ),
                        boxShadow: shadows,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCategoryChip(
                              MealCategory.all,
                              Icons.restaurant_menu,
                              'All',
                            ),
                            _buildCategoryChip(
                              MealCategory.vegetables,
                              Icons.eco,
                              'Veg',
                            ),
                            _buildCategoryChip(
                              MealCategory.meat,
                              Icons.lunch_dining,
                              'Meat',
                            ),
                            _buildCategoryChip(
                              MealCategory.seafood,
                              Icons.set_meal,
                              'Seafood',
                            ),
                            _buildCategoryChip(
                              MealCategory.rice,
                              Icons.rice_bowl,
                              'Rice',
                            ),
                            _buildCategoryChip(
                              MealCategory.noodles,
                              Icons.ramen_dining,
                              'Noodles',
                            ),
                            _buildCategoryChip(
                              MealCategory.soup,
                              Icons.soup_kitchen,
                              'Soup',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Generate button with refresh
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _generate,
                            icon: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Recommend ${_getCategoryName(_selectedCategory)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentCol,
                              foregroundColor: Colors.white,
                              iconColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        if (_plans != null) ...[
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: accentSub,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: IconButton(
                              onPressed: _refreshPlan,
                              icon: Icon(Icons.refresh, color: accentCol),
                              tooltip: 'Get new suggestions',
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Results
                    if (_plans != null)
                      ..._plans!.map(
                        (plan) => _buildDayCard(
                          plan,
                          cardCol,
                          accentCol,
                          accentSub,
                          textPri,
                          textSec,
                          shadows,
                          borderCol,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    MealCategory category,
    IconData icon,
    String label,
  ) {
    final selected = _selectedCategory == category;
    final accentCol = AppThemes.accent(
      Provider.of<ThemeProvider>(context).mode,
    );
    final textSec = AppThemes.textSecondary(
      Provider.of<ThemeProvider>(context).mode,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: FilterChip(
        selected: selected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: selected ? Colors.white : textSec),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (bool value) {
          setState(() {
            _selectedCategory = category;
            _plans = null;
          });
        },
        selectedColor: accentCol,
        checkmarkColor: Colors.white,
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: selected ? Colors.transparent : textSec.withValues(alpha: 0.3),
        ),
        labelStyle: TextStyle(
          color: selected ? Colors.white : textSec,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDayCard(
    _DayPlan plan,
    Color cardCol,
    Color accentCol,
    Color accentSub,
    Color textPri,
    Color textSec,
    List<BoxShadow> shadows,
    Color borderCol,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardCol,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderCol == Colors.transparent
              ? Colors.transparent
              : borderCol,
        ),
        boxShadow: shadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: accentCol,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.day,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Total: ₱${plan.total.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _buildMealRow(
                  Icons.wb_sunny_outlined,
                  'Breakfast',
                  plan.breakfast,
                  accentCol,
                  accentSub,
                  textPri,
                  textSec,
                ),
                const SizedBox(height: 10),
                _buildMealRow(
                  Icons.lunch_dining,
                  'Lunch',
                  plan.lunch,
                  accentCol,
                  accentSub,
                  textPri,
                  textSec,
                ),
                const SizedBox(height: 10),
                _buildMealRow(
                  Icons.dinner_dining,
                  'Dinner',
                  plan.dinner,
                  accentCol,
                  accentSub,
                  textPri,
                  textSec,
                ),
                const SizedBox(height: 10),
                _buildMealRow(
                  Icons.cookie_outlined,
                  'Snack',
                  plan.snack,
                  accentCol,
                  accentSub,
                  textPri,
                  textSec,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealRow(
    IconData icon,
    String label,
    _Meal meal,
    Color accentCol,
    Color accentSub,
    Color textPri,
    Color textSec,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: accentSub,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: accentCol),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          color: textSec,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (meal.isVegetarian) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Veg',
                            style: TextStyle(fontSize: 8, color: Colors.green),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    '₱${meal.cost.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: accentCol,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                meal.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textPri,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                meal.ingredients.join(', '),
                style: TextStyle(fontSize: 11, color: textSec),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
