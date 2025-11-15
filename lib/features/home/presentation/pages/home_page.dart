import 'package:coleccion_app/components/drawer.dart';
import 'package:coleccion_app/features/auth/presentation/components/my_textfield.dart';
import 'package:coleccion_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:coleccion_app/features/home/domain/entities/post.dart';
import 'package:coleccion_app/features/home/presentation/components/post_tile.dart';
import 'package:coleccion_app/features/home/presentation/cubits/post_cubit.dart';
import 'package:coleccion_app/features/home/presentation/cubits/post_states.dart';
import 'package:coleccion_app/features/subscriptions/presentation/cubits/subscription_cubit.dart';
import 'package:coleccion_app/features/subscriptions/presentation/cubits/subscription_states.dart';
import 'package:coleccion_app/features/subscriptions/presentation/pages/offerings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Tab controller
  late final _tabController = TabController(length: 3, vsync: this);

  // Cubits
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();

    // load posts initially
    postCubit.loadPosts();
  }

  // user wants to add new post (check pro status, only pro can make a post)
  void handleAddPost() {
    // get current subscription state from cubit
    final subscriptionState = context.read<SubscriptionCubit>().state;

    if (subscriptionState is SubscriptionLoaded && subscriptionState.isPro) {
      // user is pro: proceed to add post
      addPost();
    } else {
      // user is not pro: prompt the subscription dialog
      showSubscriptionDialog();
    }
  }

  // prompt user to subscribe
  void showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Pro Subscription",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Only pro users can post & comment."),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // subscribe button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OfferingsPage(),
                ),
              );
            },
            child: const Text("Subscribe"),
          )
        ],
      ),
    );
  }

  // add new post to a given category
  void addPost() {
    // get current category
    String currentCategory;
    switch (_tabController.index) {
      case 0:
        currentCategory = "Favoritos";
        break;
      case 1:
        currentCategory = "Placeholder1";
        break;
      case 2:
        currentCategory = "Placeholder2";
        break;
      default:
        currentCategory = "Favoritos";
    }

    // text controllers
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Post"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // title text field
            MyTextfield(
              controller: titleController,
              hintText: "Title",
              obscureText: false,
            ),

            const SizedBox(height: 16),

            // content text field
            MyTextfield(
              controller: contentController,
              hintText: "Content",
              obscureText: false,
            ),
          ],
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // post button
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                // access cubits
                final postCubit = context.read<PostCubit>();
                final authCubit = context.read<AuthCubit>();

                // create post
                postCubit.createPost(
                  title: titleController.text,
                  content: contentController.text,
                  category: currentCategory,
                  username: authCubit.currentUser!.email,
                  uid: authCubit.currentUser!.uid,
                );

                // pop box
                Navigator.pop(context);
              }
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  // delete post
  void deletePost(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          // delete button
          TextButton(
            onPressed: () {
              postCubit.deletePost(id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // Build list of posts for given category
  Widget _buildCategoryPosts(
      String category, List<Post> posts, Map<String, int> commentCounts) {
    // filter posts for this category
    final postsInThisCategory =
        posts.where((post) => post.category == category).toList();

    // posts are empty..
    if (postsInThisCategory.isEmpty) {
      return const Center(
        child: Text("Sin publicaciones"),
      );
    }

    // list of posts (for this category)
    return ListView.separated(
      itemCount: postsInThisCategory.length,
      separatorBuilder: (context, index) => Divider(
        indent: 16,
        endIndent: 16,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      itemBuilder: (context, index) {
        // get individual post
        final post = postsInThisCategory[index];

        // get comment count for this post
        final commentCount = commentCounts[post.id] ?? 0;

        // post tile
        return PostTile(
          post: post,
          onDelete: () => deletePost(post.id),
          commentCount: commentCount,
          onTap: () {
            // navigate to post page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostPage(post: post),
              ),
            );
          },
        );
      },
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text("Coleccion App"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          labelColor: Theme.of(context).colorScheme.inversePrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: "Favoritos"),
            Tab(text: "Placeholder1"),
            Tab(text: "Placeholder2"),
          ],
        ),

        // NEW POST BUTTON
        actions: [
          IconButton(
            onPressed: handleAddPost,
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      // DRAWER
      drawer: const MyDrawer(),

      // BODY
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          print(state);

          // loaded!
          if (state is PostsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryPosts("Favoritos", state.posts, state.commentCounts),
                _buildCategoryPosts("Placeholder1", state.posts, state.commentCounts),
                _buildCategoryPosts(
                    "Placeholder2", state.posts, state.commentCounts),
              ],
            );
          }

          // loading..
          if (state is PostLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // error..
          if (state is PostError) {
            return Center(
              child: Text(state.message),
            );
          }

          // fallback default
          return const SizedBox();
        },
      ),
    );
  }
}