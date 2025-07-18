import 'package:admin_panel/utilities/edit_user_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/edit_user_provider.dart';

class EditUserScreen extends StatelessWidget {
  final QueryDocumentSnapshot userData;

  const EditUserScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditUserProvider(userData: userData),
      child: Consumer<EditUserProvider>(
        builder: (context, provider, _) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0B0B0C), Color(0xFFFAF9F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text(
                  'Edit User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFAF9F6),
                  ),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: TextButton(
                      onPressed: () => provider.updateUser(
                        context,
                        userData['uid'],
                        userData['fullName'],
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF0B0B0C),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color(0xFFFAF9F6),
                        splashFactory: InkRipple.splashFactory,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.save,
                            color: Color(0xFF0B0B0C),
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Save',
                            style: TextStyle(
                              color: Color(0xFF0B0B0C),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditUserTextfield(controller: provider.emailController, labelText: 'Email',enabled: false,),

                    const SizedBox(height: 16),
                    EditUserTextfield(controller: provider.userNameController, labelText: 'Username',),

                    const SizedBox(height: 16),
                    EditUserTextfield(controller: provider.fullNameController, labelText: 'Full Name',),
                    const SizedBox(height: 16),
                    EditUserTextfield(controller: provider.phoneController, labelText: 'Phone',),
                    const SizedBox(height: 16),
                    EditUserTextfield(controller: provider.dobController, labelText: 'Date of Birth',),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      focusColor: Colors.transparent,
                      dropdownColor: const Color(0xFF6A6A6C), // Background when list is open
                      value: provider.accountType,
                      decoration: InputDecoration(
                        labelText: 'Account Type',
                        labelStyle: const TextStyle(
                          color: Color(0xFFFAF9F6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFAF9F6),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFAF9F6),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFFAF9F6),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.transparent, // Transparent when closed
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'affectee',
                          child: Text('Affectee',style: TextStyle(color: Color(0xFFFAF9F6))),
                        ),
                        DropdownMenuItem(
                          value: 'ngo',
                          child: Text('NGO',style: TextStyle(color: Color(0xFFFAF9F6)),),

                        ),
                        DropdownMenuItem(
                          value: 'volunteer',
                          child: Text('Volunteer',style: TextStyle(color: Color(0xFFFAF9F6))),
                        ),
                        DropdownMenuItem(
                          value: 'donor',
                          child: Text('Donor',style: TextStyle(color: Color(0xFFFAF9F6))),
                        ),
                      ],
                      onChanged: (value) => provider.updateAccountType(value),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Non-editable fields',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Color(0xFFFAF9F6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildNonEditableField('UID', userData['uid']),
                    _buildNonEditableField(
                      'Image URL',
                      userData['imageUrl'] ?? 'N/A',
                    ),
                    _buildNonEditableField(
                      'Created Time',
                      userData['createdTime']?.toDate().toString() ?? 'N/A',
                    ),
                    _buildNonEditableField('Role', userData['role'] ?? 'N/A'),
                    _buildNonEditableField(
                      'Email Verified',
                      userData['emailVerified'].toString(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNonEditableField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 14, color: Color(0xFFFAF9F6)),
      ),
    );
  }
}
