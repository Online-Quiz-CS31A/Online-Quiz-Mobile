import 'package:flutter/material.dart';
import '../../models/mock_data.dart';
import '../../models/user.dart';
import '../../models/quiz.dart';
import '../../models/course.dart';
import 'quiz_detail_screen.dart';
import '../../widgets/empty_state_widget.dart';

class QuizTab extends StatefulWidget {
  const QuizTab({super.key});

  @override
  State<QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<QuizTab> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Pending', 'Completed'];
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final User user = DummyData.getUser();
    final List<Quiz> allQuizzes = _getAllQuizzes(user);
    final List<Quiz> filteredQuizzes = _getFilteredQuizzes(allQuizzes);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (allQuizzes.isNotEmpty) ...[
              _buildFilterTabs(),
              _buildQuizStats(allQuizzes),
            ],
            Expanded(
              child: allQuizzes.isEmpty
                  ? _buildEmptyState()
                  : _buildQuizList(filteredQuizzes, user),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.quiz,
              color: Colors.blue,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Quizzes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Take your quizzes and track progress',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: _filterOptions.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                  _currentPage = 0; // Reset to first page when filter changes
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  filter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuizStats(List<Quiz> allQuizzes) {
    final completedCount = allQuizzes.where((quiz) => quiz.isCompleted).length;
    final pendingCount = allQuizzes.length - completedCount;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('Total', allQuizzes.length.toString(), Colors.blue),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildStatItem('Pending', pendingCount.toString(), Colors.orange),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildStatItem('Completed', completedCount.toString(), Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizList(List<Quiz> quizzes, User user) {
    if (quizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${_selectedFilter.toLowerCase()} quizzes found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new quizzes',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    final paginatedQuizzes = _getPaginatedQuizzes(quizzes);
    final totalPages = (quizzes.length / _itemsPerPage).ceil();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: paginatedQuizzes.length,
            itemBuilder: (context, index) {
              final quiz = paginatedQuizzes[index];
              final course = _getCourseForQuiz(quiz, user);
              return _buildQuizCard(quiz, course);
            },
          ),
        ),
        if (quizzes.length > _itemsPerPage) _buildPaginationControls(totalPages),
      ],
    );
  }

  Widget _buildQuizCard(Quiz quiz, Course? course) {
    final isCompleted = quiz.isCompleted;
    final isOverdue = !isCompleted && quiz.dueDate.isBefore(DateTime.now());
    final daysUntilDue = quiz.dueDate.difference(DateTime.now()).inDays;
    
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    if (isCompleted) {
      statusColor = Colors.green;
      statusText = 'Completed';
      statusIcon = Icons.check_circle;
    } else if (isOverdue) {
      statusColor = Colors.red;
      statusText = 'Overdue';
      statusIcon = Icons.error;
    } else {
      statusColor = Colors.orange;
      statusText = daysUntilDue == 0 ? 'Due Today' : 'Due in $daysUntilDue ${daysUntilDue == 1 ? 'day' : 'days'}';
      statusIcon = Icons.schedule;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToQuizDetail(quiz, course),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quiz Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        statusIcon,
                        color: statusColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          if (course != null)
                            Text(
                              '${course.code} - ${course.name}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Quiz Details
                Row(
                  children: [
                    _buildDetailItem(Icons.help_outline, '${quiz.totalQuestions} Questions'),
                    const SizedBox(width: 20),
                    _buildDetailItem(Icons.timer_outlined, '${quiz.timeLimit} min'),
                    const SizedBox(width: 20),
                    _buildDetailItem(Icons.calendar_today_outlined, _formatDate(quiz.dueDate)),
                  ],
                ),
                
                if (isCompleted && quiz.result != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.grade,
                          color: Colors.green.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Score: ${quiz.result!.correctAnswers}/${quiz.result!.totalQuestions} (${quiz.result!.percentage.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return EmptyStatePresets.quizzes();
  }

  List<Quiz> _getAllQuizzes(User user) {
    List<Quiz> allQuizzes = [];
    for (var course in user.courses) {
      allQuizzes.addAll(course.quizzes);
    }
    // Sort by due date (earliest first)
    allQuizzes.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return allQuizzes;
  }

  List<Quiz> _getPaginatedQuizzes(List<Quiz> quizzes) {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, quizzes.length);
    return quizzes.sublist(startIndex, endIndex);
  }

  Widget _buildPaginationControls(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 0 ? () {
              setState(() {
                _currentPage--;
              });
            } : null,
            icon: const Icon(Icons.chevron_left),
            iconSize: 20,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${_currentPage + 1} / $totalPages',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          IconButton(
            onPressed: _currentPage < totalPages - 1 ? () {
              setState(() {
                _currentPage++;
              });
            } : null,
            icon: const Icon(Icons.chevron_right),
            iconSize: 20,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ),
    );
  }

  List<Quiz> _getFilteredQuizzes(List<Quiz> allQuizzes) {
    List<Quiz> filtered;
    switch (_selectedFilter) {
      case 'Pending':
        filtered = allQuizzes.where((quiz) => !quiz.isCompleted).toList();
        break;
      case 'Completed':
        filtered = allQuizzes.where((quiz) => quiz.isCompleted).toList();
        break;
      default:
        // For 'All', prioritize pending quizzes first
        final pending = allQuizzes.where((quiz) => !quiz.isCompleted).toList();
        final completed = allQuizzes.where((quiz) => quiz.isCompleted).toList();
        filtered = [...pending, ...completed];
        break;
    }
    
    // Sort pending quizzes by due date (earliest first)
    // Sort completed quizzes by completion date (most recent first)
    if (_selectedFilter == 'Pending' || _selectedFilter == 'All') {
      final pendingQuizzes = filtered.where((quiz) => !quiz.isCompleted).toList();
      pendingQuizzes.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      
      if (_selectedFilter == 'All') {
        final completedQuizzes = filtered.where((quiz) => quiz.isCompleted).toList();
        completedQuizzes.sort((a, b) => b.result!.completedAt.compareTo(a.result!.completedAt));
        filtered = [...pendingQuizzes, ...completedQuizzes];
      } else {
        filtered = pendingQuizzes;
      }
    } else if (_selectedFilter == 'Completed') {
      filtered.sort((a, b) => b.result!.completedAt.compareTo(a.result!.completedAt));
    }
    
    return filtered;
  }

  Course? _getCourseForQuiz(Quiz quiz, User user) {
    for (var course in user.courses) {
      if (course.quizzes.any((q) => q.id == quiz.id)) {
        return course;
      }
    }
    return null;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 1) {
      return 'In $difference ${difference == 1 ? 'day' : 'days'}';
    } else {
      return '${difference.abs()} ${difference.abs() == 1 ? 'day' : 'days'} ago';
    }
  }

  void _navigateToQuizDetail(Quiz quiz, Course? course) {
    if (course != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizDetailScreen(
            quiz: quiz,
            course: course,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course not found for ${quiz.title}'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}