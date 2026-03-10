import 'package:flutter/material.dart';

class SwipeActionTile extends StatefulWidget {
  const SwipeActionTile({
    super.key,
    required this.child,
    required this.onEdit,
    required this.onDelete,
    this.borderRadius = 14,
    this.actionWidth = 88,
  });

  final Widget child;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double borderRadius;
  final double actionWidth;

  @override
  State<SwipeActionTile> createState() => _SwipeActionTileState();
}

class _SwipeActionTileState extends State<SwipeActionTile> {
  double _dragOffset = 0;

  double get _maxReveal => widget.actionWidth * 2;

  void _handleDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta ?? 0;
    final double nextOffset = (_dragOffset + delta).clamp(-_maxReveal, 0);
    if (nextOffset != _dragOffset) {
      setState(() {
        _dragOffset = nextOffset;
      });
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    final double velocity = details.primaryVelocity ?? 0;
    if (velocity < -250) {
      _openActions();
      return;
    }
    if (velocity > 250) {
      _closeActions();
      return;
    }

    if (_dragOffset.abs() > _maxReveal / 2) {
      _openActions();
    } else {
      _closeActions();
    }
  }

  void _openActions() {
    setState(() {
      _dragOffset = -_maxReveal;
    });
  }

  void _closeActions() {
    if (_dragOffset == 0) {
      return;
    }
    setState(() {
      _dragOffset = 0;
    });
  }

  void _handleEdit() {
    _closeActions();
    widget.onEdit();
  }

  void _handleDelete() {
    _closeActions();
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _SwipeActionButton(
                  width: widget.actionWidth,
                  backgroundColor: const Color(0xFF1E88E5),
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: _handleEdit,
                ),
                _SwipeActionButton(
                  width: widget.actionWidth,
                  backgroundColor: const Color(0xFFE53935),
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  onTap: _handleDelete,
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(_dragOffset, 0, 0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _dragOffset == 0 ? null : _closeActions,
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeActionButton extends StatelessWidget {
  const _SwipeActionButton({
    required this.width,
    required this.backgroundColor,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final double width;
  final Color backgroundColor;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
