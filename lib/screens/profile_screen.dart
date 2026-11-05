import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'profile/interests_edit_section.dart';
import 'profile/looking_for_edit_section.dart';
import 'profile/profile_header.dart';
import 'profile/profile_view.dart';

/// Profile tab / person page. Switches between a read-only view and, for the
/// current user, an edit mode. Data comes from the profile providers.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
    this.isCurrentUser = true,
    this.displayName = "Brendan O'Sullivan",
  });

  final bool isCurrentUser;
  final String displayName;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _bioController;
  String _avatarLabel = 'A';
  bool _hasBackgroundImage = false;
  bool _isViewingProfile = true;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: ref.read(profileProvider).bio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _toggleAvatar() =>
      setState(() => _avatarLabel = _avatarLabel == 'A' ? 'M' : 'A');

  @override
  Widget build(BuildContext context) {
    final profile = widget.isCurrentUser
        ? ref.watch(profileProvider)
        : ref.watch(otherProfileProvider(widget.displayName));
    final toggle = ProfileModeToggle(
      isViewing: _isViewingProfile,
      onPressed: () => setState(() => _isViewingProfile = !_isViewingProfile),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: SingleChildScrollView(
          child: _isViewingProfile
              ? ProfileView(
                  profile: profile,
                  displayName: widget.displayName,
                  avatarLabel: _avatarLabel,
                  isCurrentUser: widget.isCurrentUser,
                  toggle: toggle,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileEditHeader(
                      displayName: widget.displayName,
                      avatarLabel: _avatarLabel,
                      bioController: _bioController,
                      onBioChanged: ref.read(profileProvider.notifier).setBio,
                      hasBackgroundImage: _hasBackgroundImage,
                      onToggleAvatar: _toggleAvatar,
                      onToggleBackground: () => setState(
                        () => _hasBackgroundImage = !_hasBackgroundImage,
                      ),
                      toggle: widget.isCurrentUser ? toggle : const SizedBox(),
                    ),
                    const SizedBox(height: 24),
                    const LookingForEditSection(),
                    const SizedBox(height: 24),
                    const InterestsEditSection(),
                  ],
                ),
        ),
      ),
    );
  }
}
