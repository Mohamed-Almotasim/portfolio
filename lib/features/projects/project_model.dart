class Project {
  const Project({
    required this.title,
    required this.description,
    required this.techStack,
    required this.demoUrl,
    required this.githubUrl,
  });

  final String title;
  final String description;
  final List<String> techStack;
  final String demoUrl;
  final String githubUrl;
}
