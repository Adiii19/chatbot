# chatbot

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

Some things i learned in through this project:
1. Instead of using the Futurebuilder use a boolean variable variable to render widgets conditinally.

2. TO use the value of texeditiing controller convert it using the Map<string,dynamic> function .This function will return the value like this
   Map<String, dynamic> createQuery() {
  return {
    "contents": [{
      "parts": [{"text": promptcontroller.text}]
    }]
  };


  3. how to render text like chatgpt in your app
     
  void startWordAnimation() {
    wordTimer?.cancel();
    wordTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (currentWordIndex < words.length) {
        setState(() {
          currentWordIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  timer.periodic is used to run the callback function after the interval mentioned in the duration. 
  child: Text(
                            words.take(currentWordIndex).join(' '),

                            this prints the first n(currentWordIndex) words of the words list ..The currentwordindex increaments after the mentioned interval.

4. Input box border
      border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Change the radius here
                    borderSide: BorderSide(
                      color: const Color.fromARGB(
                          255, 233, 233, 233), // Default border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(
                          255, 244, 244, 244), // Focused border color
                    ),
                  ),

5. If you are planining to change the height of a container using a bool value , make sure that it is initialized with a value .