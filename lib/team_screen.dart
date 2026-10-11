import 'package:flutter/material.dart';

import 'models.dart';
import 'routes.dart';
import 'sample_data.dart';
import 'sla_helper.dart';
import 'task_store.dart';
import 'theme.dart';
import 'widgets.dart';

/// Person 4: Team Members/Profile screen.
///
/// It uses the same shared task list as the Tasks screen, so assignment counts
/// update immediately whenever taskStore adds, edits, or deletes a task.
class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  String _query = '';
  String _sort = 'name';

  @override
  void initState() {
    super.initState();
    taskStore.addListener(_refresh);
  }

  @override
  void dispose() {
    taskStore.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _openMemberProfile(TeamMember member) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _MemberProfileScreen(member: member),
      ),
    );
  }

  int _statusCount(Iterable<Task> tasks, SlaStatus status) {
    return tasks.where((task) => calculateSla(task) == status).length;
  }

  List<TeamMember> _visibleMembers() {
    final members = sampleMembers.where((member) {
      final search = _query.trim().toLowerCase();
      if (search.isEmpty) return true;
      return member.name.toLowerCase().contains(search) ||
          member.role.toLowerCase().contains(search);
    }).toList();

    if (_sort == 'workload') {
      members.sort((a, b) => taskStore
          .tasksForMember(b.name)
          .length
          .compareTo(taskStore.tasksForMember(a.name).length));
    } else {
      members.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }

    return members;
  }

  void _showActionMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Expanded(child: Text(message)),
            IconButton(
              tooltip: 'Close',
              visualDensity: VisualDensity.compact,
              color: Colors.white,
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: messenger.hideCurrentSnackBar,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetTasks() async {
    await taskStore.resetToSampleTasks();
    if (!mounted) return;
    _showActionMessage('Sample tasks restored.');
  }

  @override
  Widget build(BuildContext context) {
    final tasks = taskStore.tasks;
    final members = _visibleMembers();
    final signedInUser = ModalRoute.of(context)?.settings.arguments as TeamMember?;
    final completed = tasks.where((task) => task.isCompleted).length;
    final attention = tasks.where((task) {
      final status = calculateSla(task);
      return status == SlaStatus.atRisk || status == SlaStatus.overdue;
    }).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeamHero(
            memberCount: sampleMembers.length,
            taskCount: tasks.length,
            completedCount: completed,
            attentionCount: attention,
          ),
          const SizedBox(height: AppSpacing.large),
          _TeamControls(
            queryChanged: (value) => setState(() => _query = value),
            sort: _sort,
            sortChanged: (value) {
              if (value != null) setState(() => _sort = value);
            },
          ),
          const SizedBox(height: AppSpacing.medium),
          if (members.isEmpty)
            const _NoMembersFound()
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 1180
                    ? 4
                    : constraints.maxWidth >= 720
                        ? 2
                        : 1;
                const gap = AppSpacing.medium;
                final cardWidth =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: members.map((member) {
                    final assigned = taskStore.tasksForMember(member.name);
                    final completedTasks =
                        assigned.where((task) => task.isCompleted).length;

                    return SizedBox(
                      width: cardWidth,
                      child: _MemberCard(
                        member: member,
                        assignedTasks: assigned,
                        completedTasks: completedTasks,
                        overdueCount: _statusCount(assigned, SlaStatus.overdue),
                        atRiskCount: _statusCount(assigned, SlaStatus.atRisk),
                        isSignedIn: signedInUser?.id == member.id,
                        onTap: () => _openMemberProfile(member),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          const SizedBox(height: AppSpacing.large),
          _StorageStatus(
            taskCount: tasks.length,
            onReset: _resetTasks,
          ),
        ],
      ),
    );
  }
}

class _TeamHero extends StatelessWidget {
  final int memberCount;
  final int taskCount;
  final int completedCount;
  final int attentionCount;

  const _TeamHero({
    required this.memberCount,
    required this.taskCount,
    required this.completedCount,
    required this.attentionCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF17245C), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Wrap(
        spacing: AppSpacing.large,
        runSpacing: AppSpacing.large,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TEAM',
                  style: TextStyle(
                    color: Color(0xFFC7D2FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your team, at a glance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Track progress, spot risks, and keep everyone on schedule.',
                  style: TextStyle(
                    color: Color(0xFFE4E8FF),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: [
              _HeroMetric(
                icon: Icons.group_outlined,
                value: memberCount,
                label: 'Members',
              ),
              _HeroMetric(
                icon: Icons.list_alt_outlined,
                value: taskCount,
                label: 'Tasks',
              ),
              _HeroMetric(
                icon: Icons.task_alt,
                value: completedCount,
                label: 'Completed',
              ),
              _HeroMetric(
                icon: Icons.warning_amber_rounded,
                value: attentionCount,
                label: 'Need attention',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _HeroMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(238),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$value',
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamControls extends StatelessWidget {
  final ValueChanged<String> queryChanged;
  final String sort;
  final ValueChanged<String?> sortChanged;

  const _TeamControls({
    required this.queryChanged,
    required this.sort,
    required this.sortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 640;
        final search = TextField(
          onChanged: queryChanged,
          decoration: InputDecoration(
            hintText: 'Search team members...',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE3E7F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        );

        final sorting = DropdownButtonFormField<String>(
          initialValue: sort,
          onChanged: sortChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE3E7F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'name', child: Text('Name (A-Z)')),
            DropdownMenuItem(value: 'workload', child: Text('Most tasks')),
          ],
        );

        if (compact) {
          return Column(
            children: [
              search,
              const SizedBox(height: AppSpacing.small),
              sorting,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: search),
            const SizedBox(width: AppSpacing.medium),
            SizedBox(width: 190, child: sorting),
          ],
        );
      },
    );
  }
}

class _MemberCard extends StatelessWidget {
  final TeamMember member;
  final List<Task> assignedTasks;
  final int completedTasks;
  final int overdueCount;
  final int atRiskCount;
  final bool isSignedIn;
  final VoidCallback onTap;

  const _MemberCard({
    required this.member,
    required this.assignedTasks,
    required this.completedTasks,
    required this.overdueCount,
    required this.atRiskCount,
    required this.isSignedIn,
    required this.onTap,
  });

  Color get _avatarColor {
    const colors = [
      Color(0xFF2D4AA8),
      Color(0xFF7A43C6),
      Color(0xFFC83468),
      Color(0xFF199C6A),
    ];
    return colors[member.id.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final total = assignedTasks.length;
    final progress = total == 0 ? 0.0 : completedTasks / total;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE3E7F0)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: _avatarColor,
                        child: Text(
                          member.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -1,
                        bottom: -1,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: overdueCount > 0 || atRiskCount > 0
                                ? AppColors.atRisk
                                : AppColors.onTrack,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                member.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                            if (isSignedIn) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(18),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'You',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          member.role,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  SizedBox(
                    width: 58,
                    height: 58,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 58,
                          height: 58,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 5,
                            backgroundColor: const Color(0xFFE8ECF5),
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$completedTasks of $total tasks',
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'completed',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              Row(
                children: [
                  Expanded(
                    child: _MiniStatus(
                      icon: Icons.error_outline,
                      count: overdueCount,
                      label: 'Overdue',
                      color: AppColors.overdue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MiniStatus(
                      icon: Icons.warning_amber_rounded,
                      count: atRiskCount,
                      label: 'At risk',
                      color: AppColors.atRisk,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MiniStatus(
                      icon: Icons.task_alt,
                      count: completedTasks,
                      label: 'Completed',
                      color: AppColors.onTrack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.medium),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: onTap,
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('View profile'),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary.withAlpha(14),
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStatus extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color color;

  const _MiniStatus({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                '$count',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StorageStatus extends StatelessWidget {
  final int taskCount;
  final VoidCallback onReset;

  const _StorageStatus({required this.taskCount, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E7F0)),
      ),
      child: Wrap(
        spacing: AppSpacing.medium,
        runSpacing: AppSpacing.small,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.save_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$taskCount tasks saved on this device',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Saved tasks load again when the app opens.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          OutlinedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Reset to sample tasks'),
          ),
        ],
      ),
    );
  }
}

class _NoMembersFound extends StatelessWidget {
  const _NoMembersFound();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E7F0)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 36, color: AppColors.textGrey),
          SizedBox(height: 8),
          Text(
            'No matching team member',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberProfileScreen extends StatefulWidget {
  final TeamMember member;

  const _MemberProfileScreen({required this.member});

  @override
  State<_MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<_MemberProfileScreen> {
  @override
  void initState() {
    super.initState();
    taskStore.addListener(_refresh);
  }

  @override
  void dispose() {
    taskStore.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  Future<void> _setTaskCompleted(Task task, bool isCompleted) async {
    await taskStore.setTaskCompletion(task.id, isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = taskStore.tasksForMember(widget.member.name);
    final completed = tasks.where((task) => task.isCompleted).length;
    final progress = tasks.isEmpty ? 0.0 : completed / tasks.length;

    int countStatus(SlaStatus status) =>
        tasks.where((task) => calculateSla(task) == status).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Member Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeader(member: widget.member),
            const SizedBox(height: AppSpacing.large),
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: AppSpacing.small),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 900
                    ? 4
                    : constraints.maxWidth >= 520
                        ? 2
                        : 1;
                const gap = AppSpacing.small;
                final width =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    SizedBox(
                      width: width,
                      child: _OverviewTile(
                        label: 'On Track',
                        value: countStatus(SlaStatus.onTrack),
                        status: SlaStatus.onTrack,
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: _OverviewTile(
                        label: 'At Risk',
                        value: countStatus(SlaStatus.atRisk),
                        status: SlaStatus.atRisk,
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: _OverviewTile(
                        label: 'Overdue',
                        value: countStatus(SlaStatus.overdue),
                        status: SlaStatus.overdue,
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: _OverviewTile(
                        label: 'Completed',
                        value: completed,
                        status: SlaStatus.completed,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.medium),
            _ProgressCard(
              completed: completed,
              total: tasks.length,
              progress: progress,
            ),
            const SizedBox(height: AppSpacing.large),
            Text(
              'Assigned tasks (${tasks.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: AppSpacing.small),
            if (tasks.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.large),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE3E7F0)),
                ),
                child: const Text('No tasks assigned to this member.'),
              )
            else
              ...tasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.small),
                  child: _ProfileTaskRow(
                    task: task,
                    formattedDate: _formatDate(task.deadline),
                    onCompletedChanged: (value) {
                      if (value != null) {
                        _setTaskCompleted(task, value);
                      }
                    },
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.taskDetails,
                      arguments: task,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final TeamMember member;

  const _ProfileHeader({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.large),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF1F4FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3E7F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: AppColors.primary,
            child: Text(
              member.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.role,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 17,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Project team member',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewTile extends StatelessWidget {
  final String label;
  final int value;
  final SlaStatus status;

  const _OverviewTile({
    required this.label,
    required this.value,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: status.color.withAlpha(16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: status.color.withAlpha(38)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: status.color.withAlpha(18),
              shape: BoxShape.circle,
            ),
            child: Icon(status.icon, color: status.color, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value',
                style: TextStyle(
                  color: status.color,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final double progress;

  const _ProgressCard({
    required this.completed,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E7F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Task completion',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              Text(
                '$completed of $total completed',
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE8ECF5),
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTaskRow extends StatelessWidget {
  final Task task;
  final String formattedDate;
  final ValueChanged<bool?> onCompletedChanged;
  final VoidCallback onTap;

  const _ProfileTaskRow({
    required this.task,
    required this.formattedDate,
    required this.onCompletedChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = calculateSla(task);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE3E7F0)),
          ),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: onCompletedChanged,
                activeColor: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Due $formattedDate • ${task.priority} priority',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusLabel(status: status),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
