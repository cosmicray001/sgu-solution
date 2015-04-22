/* SGU ID:  #166
 * Type  :  String Processing
 * Author:  Hangchen Yu
 * Date  :  04/18/2015
 */
#include <iostream>
#include <string>
#include <cstdio>

using namespace std;

struct Line {
    string s;
    Line* prev, * next;

    Line(string content = "") {
        s = content;
        prev = next = NULL;
    }
};

class Editor {
    Line* firstLine, * currentLine;
    int currentPos;

public:
    Editor() {
        firstLine = new Line;
        currentLine = firstLine;
        currentPos = 0;
    }

    //I
    void insert(char x) {
        int currentLength = currentLine->s.length();
        if (currentPos >= currentLength) {
            for (int i = 0; i < currentPos-currentLength; i++)
                currentLine->s += ' ';
            currentLine->s += x;
            currentPos = currentLine->s.length();
        }
        else {
            currentLine->s.insert(currentPos, 1, x);
            currentPos++;
        }
    }

    //L
    void moveLeft() {
        if (currentPos > 0) currentPos--;
    }

    //R
    void moveRight() {
        currentPos++;
    }

    //U
    void moveUp() {
        if (currentLine->prev)
            currentLine = currentLine->prev;
    }

    //D
    void moveDown() {
        if (currentLine->next)
            currentLine = currentLine->next;
    }

    //N
    void newLine() {
        if (currentPos > currentLine->s.length())
            currentPos = currentLine->s.length();
        Line* tmpLine;
        tmpLine = currentLine->next;
        currentLine->next = new Line(currentLine->s.substr(currentPos, currentLine->s.length()-currentPos));
        currentLine->next->prev = currentLine;
        currentLine->next->next = tmpLine;
        if (tmpLine) tmpLine->prev = currentLine->next;
        currentLine->s = currentLine->s.substr(0, currentPos);
        currentLine = currentLine->next;
        currentPos = 0;
    }

    //E
    void jmpEnd() {
        currentPos = currentLine->s.length();
    }

    //H
    void jmpHead() {
        currentPos = 0;
    }

    //X
    void delCurrentSymbol() {
        if (currentPos < currentLine->s.length()) {
            currentLine->s.erase(currentPos, 1);
        }
        else if (currentLine->next) {
            int currentLength = currentLine->s.length();
            for (int i = 0; i < currentPos-currentLength; i++)
                currentLine->s += ' ';
            currentLine->s += currentLine->next->s;
            Line* tmpLine = currentLine->next;
            if (tmpLine->next) tmpLine->next->prev = currentLine;
            currentLine->next = tmpLine->next;
            delete tmpLine;
        }
    }

    //B
    void delPreviousSymbol() {
        if (!currentPos) {
            if (currentLine->prev) {
                currentPos = currentLine->prev->s.length();
                currentLine->prev->s += currentLine->s;
                currentLine->prev->next = currentLine->next;
                if (currentLine->next) currentLine->next->prev = currentLine->prev;
                Line* tmpLine = currentLine;
                currentLine = currentLine->prev;
                delete tmpLine;
            }
        }
        else {
            if (currentPos <= currentLine->s.length())
                currentLine->s.erase(currentPos-1, 1);
            currentPos--;
        }

    }

    //Q
    void print() {
        Line* tmpLine = firstLine;
        while (tmpLine) {
            cout << tmpLine->s;
            tmpLine = tmpLine->next;
            if (tmpLine) cout << endl;
        }
    }
};

int main() {
    Editor editor;
    char c;
    while ((c=getchar())!=EOF) {
        switch (c) {
            case 'L':
                editor.moveLeft();
                break;
            case 'R':
                editor.moveRight();
                break;
            case 'U':
                editor.moveUp();
                break;
            case 'D':
                editor.moveDown();
                break;
            case 'N':
                editor.newLine();
                break;
            case 'E':
                editor.jmpEnd();
                break;
            case 'H':
                editor.jmpHead();
                break;
            case 'X':
                editor.delCurrentSymbol();
                break;
            case 'B':
                editor.delPreviousSymbol();
                break;
            case 'Q':
                editor.print();
                return 0;
            case '\n':
                editor.print();
                return 0;
            default:
                if ((c >= 'a' && c <= 'z') || c == ' ')
                    editor.insert(c);
        }

        //cout << "======== " << c << " =======\n";
        //editor.print();
        //cout << endl << endl;

    }

    return 0;
}
