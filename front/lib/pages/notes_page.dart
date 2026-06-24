import 'package:flutter/material.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';

class NotesPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const NotesPage({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Note> _notes = [];
  final List<String> _openTabIds = [];
  String? _activeTabId;
  int _nextId = 1;

  final Map<String, TextEditingController> _titleControllers = {};
  final Map<String, TextEditingController> _contentControllers = {};

  Note? get _activeNote {
    if (_activeTabId == null) return null;
    try {
      return _notes.firstWhere((n) => n.id == _activeTabId);
    } catch (_) {
      return null;
    }
  }

  Color get _bg          => widget.isDark ? AppPalette.darkBg          : AppPalette.lightBg;
  Color get _sidebar     => widget.isDark ? AppPalette.darkSidebar     : AppPalette.lightSidebar;
  Color get _surface     => widget.isDark ? AppPalette.darkSurface     : AppPalette.lightSurface;
  Color get _border      => widget.isDark ? AppPalette.darkBorder      : AppPalette.lightBorder;
  Color get _text        => widget.isDark ? AppPalette.darkText        : AppPalette.lightText;
  Color get _textMuted   => widget.isDark ? AppPalette.darkTextMuted   : AppPalette.lightTextMuted;
  Color get _accent      => widget.isDark ? AppPalette.darkAccent      : AppPalette.lightAccent;
  Color get _tabActive   => widget.isDark ? AppPalette.darkTabActive   : AppPalette.lightTabActive;
  Color get _tabInactive => widget.isDark ? AppPalette.darkTabInactive : AppPalette.lightTabInactive;

  // ── Acciones ─────────────────────────────────────────────────────────────────
  void _createNote() {
    final id = '${_nextId++}';
    final note = Note(id: id, title: 'Nueva nota', content: '');
    _titleControllers[id] = TextEditingController(text: note.title);
    _contentControllers[id] = TextEditingController(text: note.content);
    setState(() {
      _notes.add(note);
      _openTab(id);
    });
  }

  void _openTab(String id) {
    if (!_openTabIds.contains(id)) _openTabIds.add(id);
    _activeTabId = id;
  }

  void _closeTab(String id) {
    final idx = _openTabIds.indexOf(id);
    _openTabIds.remove(id);
    if (_activeTabId == id) {
      _activeTabId = _openTabIds.isEmpty
          ? null
          : _openTabIds[idx.clamp(0, _openTabIds.length - 1)];
    }
  }

  void _onSidebarNoteTap(String id) => setState(() => _openTab(id));

  void _onTitleChanged(String id, String val) {
    setState(() {
      _notes.firstWhere((n) => n.id == id).title =
      val.isEmpty ? 'Sin título' : val;
    });
  }

  void _onContentChanged(String id, String val) =>
      _notes.firstWhere((n) => n.id == id).content = val;

  void _deleteNote(String id) {
    setState(() {
      _closeTab(id);
      _notes.removeWhere((n) => n.id == id);
      _titleControllers.remove(id)?.dispose();
      _contentControllers.remove(id)?.dispose();
    });
  }

  @override
  void dispose() {
    for (final c in _titleControllers.values) c.dispose();
    for (final c in _contentControllers.values) c.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: Row(
              children: [
                _buildSidebar(),
                Container(width: 1, color: _border),
                Expanded(child: _buildMainArea()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 48,
      color: _sidebar,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.edit_note_rounded, color: _accent, size: 22),
          const SizedBox(width: 8),
          Text(
            'Mis notas',
            style: TextStyle(
              color: _text,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 20,
              color: _textMuted,
            ),
            tooltip: widget.isDark ? 'Modo claro' : 'Modo oscuro',
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return SizedBox(
      width: 200,
      child: Container(
        color: _sidebar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: _createNote,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _accent.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 16, color: _accent),
                      const SizedBox(width: 6),
                      Text(
                        'Nueva nota',
                        style: TextStyle(
                          color: _accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(color: _border, height: 1),
            const SizedBox(height: 4),
            Expanded(
              child: _notes.isEmpty
                  ? Center(
                child: Text(
                  'Sin notas',
                  style: TextStyle(color: _textMuted, fontSize: 13),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                itemCount: _notes.length,
                itemBuilder: (_, i) => _buildSidebarItem(_notes[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(Note note) {
    final isActive = note.id == _activeTabId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () => _onSidebarNoteTap(note.id),
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? _accent.withValues(alpha: 0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 14,
                color: isActive ? _accent : _textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isActive ? _text : _textMuted,
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
              InkWell(
                onTap: () => setState(() => _deleteNote(note.id)),
                borderRadius: BorderRadius.circular(3),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(Icons.delete_outline, size: 14, color: _textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainArea() {
    if (_openTabIds.isEmpty) return _buildEmptyState();
    return Column(
      children: [
        _buildTabBar(),
        Container(height: 1, color: _border),
        Expanded(child: _buildEditor()),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notes_rounded, size: 52, color: _border),
          const SizedBox(height: 16),
          Text(
            'Crea una nota para empezar',
            style: TextStyle(color: _textMuted, fontSize: 15),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _createNote,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Nueva nota'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _accent,
              side: BorderSide(color: _accent.withValues(alpha: 0.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 38,
      color: _tabInactive,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _openTabIds.map((id) {
            final note = _notes.firstWhere(
                  (n) => n.id == id,
              orElse: () => Note(id: id, title: '?', content: ''),
            );
            return _buildTab(note, id == _activeTabId);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTab(Note note, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _activeTabId = note.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isActive ? _tabActive : _tabInactive,
          border: Border(
            right: BorderSide(color: _border),
            bottom: isActive
                ? BorderSide(color: _accent, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sticky_note_2_outlined,
              size: 13,
              color: isActive ? _accent : _textMuted,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isActive ? _text : _textMuted,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: () => setState(() => _closeTab(note.id)),
              borderRadius: BorderRadius.circular(3),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(Icons.close, size: 13, color: _textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditor() {
    final note = _activeNote;
    if (note == null) return const SizedBox.shrink();

    final titleCtrl   = _titleControllers[note.id]!;
    final contentCtrl = _contentControllers[note.id]!;

    return Container(
      color: _surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 4),
            child: TextField(
              controller: titleCtrl,
              onChanged: (v) => _onTitleChanged(note.id, v),
              style: TextStyle(
                color: _text,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
              decoration: InputDecoration(
                hintText: 'Título',
                hintStyle: TextStyle(
                  color: _textMuted,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Divider(color: _border, indent: 32, endIndent: 32),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 24),
              child: TextField(
                controller: contentCtrl,
                onChanged: (v) => _onContentChanged(note.id, v),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(color: _text, fontSize: 15, height: 1.65),
                decoration: InputDecoration(
                  hintText: 'Empieza a escribir…',
                  hintStyle: TextStyle(color: _textMuted, fontSize: 15),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}