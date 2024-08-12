#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mar 13 2024
@author: MohammadHossein Salari
@email: mohammadHossein.salari@gmail.com
"""

import time
import pyttsx3


def say_and_count(participant_id):
    # Initialize the text-to-speech engine
    engine = pyttsx3.init()

    try:

        # participant ID
        id_text = f"Participant ID: {participant_id}"
        print(id_text)
        engine.say(id_text)
        engine.runAndWait()
        time.sleep(0.5)

        # Record
        info_text = "Start of recording..."
        print(info_text)
        engine.say(info_text)
        engine.runAndWait()
        time.sleep(1)

        # Count from 1 to 9 with a 1-second interval
        for i in range(1, 10):
            count_text = str(i)
            print(count_text, end=" " if i < 9 else "", flush=True)
            engine.say(count_text)
            engine.runAndWait()
            if i == 1:
                time.sleep(0.5)
            time.sleep(1.2)

        # End of Recording
        time.sleep(1)
        info_text = "\nEnd of recording..."
        print(info_text)
        engine.say(info_text)
        engine.runAndWait()

    except KeyboardInterrupt:
        # Handle KeyboardInterrupt (Ctrl+C)
        print("\nRecording interrupted. Exiting...")


if __name__ == "__main__":
    # Get participant ID from user input
    # participant_id = 1
    participant_id = input("Enter Participant ID: ")

    # Call the function with the provided participant ID
    say_and_count(participant_id)
