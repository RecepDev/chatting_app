import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// A MessageBubble for showing a single chat message on the ChatScreen.
class MessageBubblePrivate extends StatelessWidget {
  // Create a message bubble which is meant to be the first in the sequence.
  const MessageBubblePrivate.first(
      {super.key,
      required this.message,
      required this.isMe,
      required this.date,
      required this.image})
      : isFirstInSequence = true;

  // Create a amessage bubble that continues the sequence.
  const MessageBubblePrivate.next(
      {super.key,
      required this.message,
      required this.isMe,
      required this.date,
      required this.image})
      : isFirstInSequence = false;

  // Whether or not this message bubble is the first in a sequence of messages
  // from the same user.
  // Modifies the message bubble slightly for these different cases - only
  // shows user image for the first message from the same user, and changes
  // the shape of the bubble for messages thereafter.
  final bool isFirstInSequence;

  // Image of the user to be displayed next to the bubble.
  // Not required if the message is not the first in a sequence.

  // Username of the user.
  // Not required if the message is not the first in a sequence.
  final String message;
  final Timestamp date;
  final String image;

  // Controls how the MessageBubble will be aligned.
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // First messages in the sequence provide a visual buffer at
              // the top.
              if (isFirstInSequence) const SizedBox(height: 18),

              // The "speech" box surrounding the message.
              if (image == 'false')
                Container(
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.grey[300]
                        : theme.colorScheme.secondary.withAlpha(200),
                    // Only show the message bubble's "speaking edge" if first in
                    // the chain.
                    // Whether the "speaking edge" is on the left or right depends
                    // on whether or not the message bubble is the current user.
                    borderRadius: BorderRadius.only(
                      topLeft: !isMe && isFirstInSequence
                          ? Radius.zero
                          : const Radius.circular(12),
                      topRight: isMe && isFirstInSequence
                          ? Radius.zero
                          : const Radius.circular(12),
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    ),
                  ),
                  // Set some reasonable constraints on the width of the
                  // message bubble so it can adjust to the amount of text
                  // it should show.
                  constraints: const BoxConstraints(maxWidth: 280),
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 10,
                  ),
                  // Margin around the bubble.
                  margin: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 3,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Wrap(
                      /* crossAxisAlignment: isMe
                                    ? WrapCrossAlignment.end
                                    : WrapCrossAlignment.start, */
                      alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
                      runAlignment: WrapAlignment.spaceBetween,
                      children: [
                        if (!isMe)
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 2),
                            child: Text(
                              formatTimestamp(date),
                              style: TextStyle(
                                fontSize: 11, // Adjust font size if needed
                                color: isMe ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        Padding(
                          padding: isMe
                              ? const EdgeInsets.only(
                                  right: 8, bottom: 0, top: 3)
                              : const EdgeInsets.only(
                                  left: 8, bottom: 0, top: 3),
                          child: Text(
                            message,
                            softWrap: true,
                            style: TextStyle(
                              height: 1.3,
                              color: isMe
                                  ? Colors.black87
                                  : theme.colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        if (isMe)
                          Padding(
                            padding: const EdgeInsets.only(top: 10, right: 0),
                            child: Text(
                              formatTimestamp(date),
                              style: TextStyle(
                                fontSize: 11, // Adjust font size if needed
                                color: isMe ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              if (image != 'false' && message.isEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.grey[300]
                        : theme.colorScheme.secondary.withAlpha(200),
                    // Only show the message bubble's "speaking edge" if first in
                    // the chain.
                    // Whether the "speaking edge" is on the left or right depends
                    // on whether or not the message bubble is the current user.
                    borderRadius: BorderRadius.only(
                      topLeft: !isMe && isFirstInSequence
                          ? Radius.zero
                          : const Radius.circular(12),
                      topRight: isMe && isFirstInSequence
                          ? Radius.zero
                          : const Radius.circular(12),
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    ),
                  ),
                  // Set some reasonable constraints on the width of the
                  // message bubble so it can adjust to the amount of text
                  // it should show.
                  constraints:
                      const BoxConstraints(maxWidth: 205, maxHeight: 276),
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 3,
                  ),
                  // Margin around the bubble.
                  margin: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 3,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.2),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: !isMe && isFirstInSequence
                                    ? Radius.zero
                                    : const Radius.circular(9),
                                topRight: isMe && isFirstInSequence
                                    ? Radius.zero
                                    : const Radius.circular(9),
                                bottomLeft: const Radius.circular(9),
                                bottomRight: const Radius.circular(9),
                              ),
                              child: Image.network(
                                image,
                                fit: BoxFit.fill,
                                // scale: 0.2,
                                /* cacheHeight: 200,
                                    cacheWidth: 200, */
                                height: 270,
                                width: 200,
                              )),
                        ),
                        /*  Text(
                              message,
                              softWrap: true,
                              style: TextStyle(
                                height: 1.3,
                                color: isMe
                                    ? Colors.black87
                                    : theme.colorScheme.onSecondary,
                              ),
                            ), */
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Text(
                            formatTimestamp(date),
                            style: const TextStyle(
                              fontSize: 11, // Adjust font size if needed
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (image != 'false' && message.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.grey[300]
                        : theme.colorScheme.secondary.withAlpha(200),
                    // Only show the message bubble's "speaking edge" if first in
                    // the chain.
                    // Whether the "speaking edge" is on the left or right depends
                    // on whether or not the message bubble is the current user.
                    borderRadius: BorderRadius.only(
                      topLeft: !isMe && isFirstInSequence
                          ? Radius.zero
                          : const Radius.circular(12),
                      topRight: isMe && isFirstInSequence
                          ? Radius.zero
                          : const Radius.circular(12),
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    ),
                  ),
                  // Set some reasonable constraints on the width of the
                  // message bubble so it can adjust to the amount of text
                  // it should show.
                  constraints: const BoxConstraints(
                    maxWidth: 250,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 3,
                  ),
                  // Margin around the bubble.
                  margin: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 3,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: !isMe && isFirstInSequence
                                    ? Radius.zero
                                    : const Radius.circular(9),
                                topRight: isMe && isFirstInSequence
                                    ? Radius.zero
                                    : const Radius.circular(9),
                                bottomLeft: const Radius.circular(9),
                                bottomRight: const Radius.circular(9),
                              ),
                              child: Image.network(
                                image,
                                fit: BoxFit.fill,
                                // scale: 0.2,
                                /* cacheHeight: 200,
                                    cacheWidth: 200, */
                                height: 270,
                                width: 200,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 5),
                          child: Wrap(
                            /* crossAxisAlignment: isMe
                                    ? WrapCrossAlignment.end
                                    : WrapCrossAlignment.start, */
                            /*  */
                            alignment: WrapAlignment.end,
                            //runAlignment: WrapAlignment.start,
                            children: [
                              if (!isMe)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 7, left: 2),
                                  child: Text(
                                    formatTimestamp(date),
                                    style: TextStyle(
                                      fontSize:
                                          11, // Adjust font size if needed
                                      color: isMe ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: isMe
                                    ? const EdgeInsets.only(
                                        right: 8, bottom: 0, top: 3)
                                    : const EdgeInsets.only(left: 8, top: 3),
                                child: Text(
                                  message,
                                  softWrap: true,
                                  style: TextStyle(
                                    height: 1.3,
                                    color: isMe
                                        ? Colors.black87
                                        : theme.colorScheme.onSecondary,
                                  ),
                                ),
                              ),
                              if (isMe)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 7),
                                  child: Text(
                                    formatTimestamp(date),
                                    style: TextStyle(
                                      fontSize:
                                          11, // Adjust font size if needed
                                      color: isMe ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    var format = DateFormat().add_Hm(); // <- use skeleton here
    return format.format(timestamp.toDate());
  }
}
