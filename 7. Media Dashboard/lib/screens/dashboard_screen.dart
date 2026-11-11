import 'package:flutter/material.dart';
import '../models/article.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Celebrity and Interviews',
    'Events and Experiences',
    'Movies and Tv',
    'Sports',
  ];

  final List<Article> _allArticles = [
    Article(
      id: '1',
      title: 'HBOs Harry Potter Series Reveals New Character Posters',
      category: 'TV and Entertainment',
      summary:
          'HBO has unveiled new character posters for its upcoming Harry Potter television adaptation. The designs have sparked discussion among fans, with viewers examining how the new series will portray familiar Hogwarts characters.',
      timeAgo: '1 day ago',
      isFeatured: true,
    ),
    Article(
      id: '2',
      title: 'Disney+ Brings Star Wars Movies to Virtual Reality in 3D',
      category: 'Technology and Streaming',
      summary:
          'Disney+ has introduced an update for Meta Quest 3 and 3S, adding around 60 3D movies, including Star Wars: The Force Awakens. Fans can also watch movies in immersive virtual environments inspired by locations such as Tatooine.',
      timeAgo: '1 day ago',
    ),
    Article(
      id: '3',
      title: 'Ahsoka Season 2 Gets an Official Release Date and Teaser',
      category: 'Movies and TV',
      summary:
          'Lucasfilm has revealed the teaser trailer for Ahsoka Season 2, featuring Ahsoka Tano, Anakin Skywalker and Grand Admiral Thrawn. The new season is scheduled to premiere on Disney+ on January 20, 2027.',
      timeAgo: '88 days ago',
    ),
    Article(
      id: '4',
      title: 'Harry Potters New Oxford Street Flagship Store Opens in London',
      category: 'Events and Experiences',
      summary:
          'A new Harry Potter flagship store has officially opened on Londons Oxford Street. Designed to recreate the atmosphere of Diagon Alley, the store features magical displays and themed shopping experiences for Wizarding World fans.',
      timeAgo: '7 days ago',
    ),
    Article(
      id: '5',
      title: 'Daniel Radcliffe Shares His Thoughts on the Harry Potter Reboot',
      category: 'Celebrity and Interviews',
      summary:
          'Daniel Radcliffe has addressed the upcoming Harry Potter television reboot, discussing his position regarding the new adaptation and its younger cast. His comments have renewed conversations about the relationship between the original films and the new series.',
      timeAgo: '2 day ago',
    ),
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Simulate refreshing data
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter articles dynamically based on selected category
    final filteredArticles = _selectedCategory == 'All'
        ? _allArticles.where((a) => !a.isFeatured).toList()
        : _allArticles
              .where((a) => a.category == _selectedCategory && !a.isFeatured)
              .toList();

    final featuredArticle = _allArticles.firstWhere(
      (a) => a.isFeatured,
      orElse: () => _allArticles.first,
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            // 1. Collapsing SliverAppBar with Profile Header
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Media Dashboard',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.indigo],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.person, size: 24),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Welcome back, Diva',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Featured Article Section using Stack
                    const Text(
                      'Featured Article',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    featuredArticle.category,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  featuredArticle.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 3. Category GridView Cards
                    const Text(
                      'Explore Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 80,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisExtent: 110,
                              mainAxisSpacing: 10,
                            ),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategory == category;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedCategory = category),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Latest News (${_selectedCategory})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // 4. Dynamic SliverList for Filtered Articles
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final article = filteredArticles[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.article, color: Colors.blue),
                    title: Text(
                      article.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${article.summary}\n${article.timeAgo}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    isThreeLine: true,
                  ),
                );
              }, childCount: filteredArticles.length),
            ),
          ],
        ),
      ),
    );
  }
}
