// SP Exercise 2
// 2465714A
// This is my own work as defined in the Academic Ethics agreement I have signed
#define CRAWLER_THREADS 2;

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

#include <cstdlib>
#include <string>
#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <list>
#include <thread>
#include <iostream>
#include <chrono>
#include <algorithm>
#include <queue>
#include <optional>
#include <condition_variable>

std::condition_variable cv;
bool terminate = false;
std::vector<std::string> dirs;

struct hashMap
{
private:
  std::unordered_map<std::string, std::list<std::string> > theTable;
  std::mutex mutex;

public:
  void add_to_map(std::string file, std::list<std::string> entries) // adds the entries as pair (string and list of strings) to map
  {
    std::unique_lock<std::mutex> lock(mutex);
    theTable.insert(std::make_pair(file, entries));
  }
  bool contains(std::string fileKey) // member function checks whether fileKey is in map
  {
    std::unique_lock<std::mutex> lock(mutex);
    if (theTable.find(fileKey) != theTable.end())
    {
      return true;
    }
    return false;
  }
  std::list<std::string> *at(std::string key) // returns address of element at key
  {
    std::unique_lock<std::mutex> lock(mutex);
    if (theTable.empty())
    {
      return {};
    }
    return &theTable[key];
  }
  std::unordered_map<std::string, std::list<std::string> >::iterator find(std::string key) //returns element assigned to key
  {
    std::unique_lock<std::mutex> lock(mutex);
    if (theTable.empty())
    {
      return {};
    }
    return theTable.find(key);
  }
  std::unordered_map<std::string, std::list<std::string> >::iterator end() //returns iterator starting at the of map
  {
    std::unique_lock<std::mutex> lock(mutex);
    if (theTable.empty())
    {
      return {};
    }
    auto iter = theTable.end();
    return iter;
  }

} typedef hashMap;

// queue thread safe structure
struct queue
{
private:
  std::queue<std::string> workQ;
  std::mutex mutex;

public:
  void push_queue(std::string entry) // inserts element at the end
  {
    std::unique_lock<std::mutex> lock(mutex);
    workQ.push(entry); // inserts element at the end
  }

  std::optional<std::string> pop_queue() // removes the first element
  {
    std::unique_lock<std::mutex> lock(mutex);
    if (workQ.empty())
    {
      return {};
    }
    std::string popped = workQ.front();
    workQ.pop();
    return popped;
  }
  std::string frontQueue() //returns item which is first in queue
  {
    std::unique_lock<std::mutex> lock(mutex);
    if (workQ.empty())
    {
      return {};
    }
    return workQ.front();
  }
  int size() //returns length of the queue
  {
    std::unique_lock<std::mutex> lock(mutex);
    if (workQ.empty())
    {
      return 0;
    }
    return workQ.size();
  }
} typedef queue;

hashMap theTable;
queue workQ;

std::string dirName(const char *c_str)
{
  std::string s = c_str; // s takes ownership of the string content by allocating memory for it
  if (s.back() != '/')
  {
    s += '/';
  }
  return s;
}

std::pair<std::string, std::string> parseFile(const char *c_file)
{
  std::string file = c_file;
  std::string::size_type pos = file.rfind('.');
  if (pos == std::string::npos)
  {
    return {file, ""};
  }
  else
  {
    return {file.substr(0, pos), file.substr(pos + 1)};
  }
}

// open file using the directory search path constructed in main()
static FILE *openFile(const char *file)
{
  FILE *fd;
  for (unsigned int i = 0; i < dirs.size(); i++)
  {
    std::string path = dirs[i] + file;
    fd = fopen(path.c_str(), "r");
    if (fd != NULL)
      return fd; // return the first file that successfully opens
  }
  return NULL;
}
static void process(const char *file, std::list<std::string> *ll)
{
  char buf[4096], name[4096];
  // 1. open the file
  FILE *fd = openFile(file);
  if (fd == NULL)
  {
    fprintf(stderr, "Error opening %s\n", file);
    exit(-1);
  }
  while (fgets(buf, sizeof(buf), fd) != NULL)
  {
    char *p = buf;
    // 2a. skip leading whitespace
    while (isspace((int)*p))
    {
      p++;
    }
    // 2b. if match #include
    if (strncmp(p, "#include", 8) != 0)
    {
      continue;
    }
    p += 8; // point to first character past #include
    // 2bi. skip leading whitespace
    while (isspace((int)*p))
    {
      p++;
    }
    if (*p != '"')
    {
      continue;
    }
    // 2bii. next character is a "
    p++; // skip "
    // 2bii. collect remaining characters of file name
    char *q = name;
    while (*p != '\0')
    {
      if (*p == '"')
      {
        break;
      }
      *q++ = *p++;
    }
    *q = '\0';
    // 2bii. append file name to dependency list
    ll->push_back({name});
    // 2bii. if file name not already in table ...
    if (theTable.find(name) != theTable.end())
    {
      continue;
    }
    // ... insert mapping from file name to empty list in table ...
    theTable.add_to_map(name, {});
    // ... append file name to workQ
    workQ.push_queue(name);
  }
  // 3. close file
  fclose(fd);
}

static void printDependencies(std::unordered_set<std::string> *printed,
                              std::list<std::string> *toProcess,
                              FILE *fd)
{
  if (!printed || !toProcess || !fd)
    return;
  // 1. while there is still a file in the toProcess list
  while (toProcess->size() > 0)
  {
    // 2. fetch next file to process
    std::string name = toProcess->front();
    toProcess->pop_front();
    // 3. lookup file in the table, yielding list of dependencies
    std::list<std::string> *ll = theTable.at(name);
    // 4. iterate over dependencies
    for (auto iter = ll->begin(); iter != ll->end(); iter++)
    {
      // 4a. if filename is already in the printed table, continue
      if (printed->find(*iter) != printed->end())
      {
        continue;
      }
      // 4b. print filename
      fprintf(fd, " %s", iter->c_str());
      // 4c. insert into printed
      printed->insert(*iter);
      // 4d. append to toProcess
      toProcess->push_back(*iter);
    }
  }
}

void threadWork()
{
  // 4. for each file on the workQ
  while (workQ.size() > 0)
  {
    std::string filename = workQ.frontQueue();
    workQ.pop_queue();

    if (theTable.find(filename) == theTable.end())
    {
      fprintf(stderr, "Mismatch between table and workQ\n");
      return;
    }

    // 4a&b. lookup dependencies and invoke 'process'
    process(filename.c_str(), theTable.at(filename));
  }
}

int main(int argc, char *argv[])
{

  // 1. look up CPATH in environment
  char *cpath = getenv("CPATH");

  // determine the number of -Idir arguments
  int i;
  for (i = 1; i < argc; i++)
  {
    if (strncmp(argv[i], "-I", 2) != 0)
      break;
  }
  int start = i;

  // 2. start assembling dirs vector
  dirs.push_back(dirName("./")); // always search current directory first
  for (i = 1; i < start; i++)
  {
    dirs.push_back(dirName(argv[i] + 2 /* skip -I */));
  }
  if (cpath != NULL)
  {
    std::string str(cpath);
    std::string::size_type last = 0;
    std::string::size_type next = 0;
    while ((next = str.find(":", last)) != std::string::npos)
    {
      dirs.push_back(str.substr(last, next - last));
      last = next + 1;
    }
    dirs.push_back(str.substr(last));
  }
  // 2. finished assembling dirs vector

  // 3. for each file argument ...
  for (i = start; i < argc; i++)
  {
    std::pair<std::string, std::string> pair = parseFile(argv[i]);
    if (pair.second != "c" && pair.second != "y" && pair.second != "l")
    {
      fprintf(stderr, "Illegal extension: %s - must be .c, .y or .l\n",
              pair.second.c_str());
      return -1;
    }

    std::string obj = pair.first + ".o";

    // 3a. insert mapping from file.o to file.ext
    theTable.add_to_map(obj, {argv[i]});

    // 3b. insert mapping from file.ext to empty list
    theTable.add_to_map(argv[i], {});

    // 3c. append file.ext on workQ
    workQ.push_queue(argv[i]);
  }

  // stop main thread and wait until workers are finished
  // make main thread and run work queue
  // start workers
  // once workers complete:
  // working = false
  // and proceed to print output

  bool working = true;
  // here the pivot is defined which ensues how many threads
  // we will be using on first iteration, and adjusted if workQ is smaller than CRAWLER_THREADS
  size_t MAXTHREADS = CRAWLER_THREADS;
  size_t pivot = MAXTHREADS;
  std::vector<std::thread> threads(MAXTHREADS);

  //auto begin = std::chrono::high_resolution_clock::now();
  while (workQ.size() > 0)
  {
    // of work queue has less items than MAXTHREADS then change pivot to work queue size
    if (workQ.size() < MAXTHREADS)
    {
      pivot = workQ.size();
    }
    else
    {
      pivot = MAXTHREADS;
    }
    for (size_t i = 0; i < pivot; i++)
    {
      threads[i] = std::thread(threadWork);
    }
    for (auto &t : threads)
    {
      t.join();
    }
  }
  //auto stop = std::chrono::high_resolution_clock::now();

  //std::chrono::duration<double, std::milli> ms_deci = stop - begin;

  //std::cout << "Time taken: " << ms_deci.count() << " milliseconds." << std::endl;

  // ensure all threads are finished dealing with the queue
  while (working)
  {
    if (workQ.size() == 0)
    {
      working = false;
    }
    continue;
  }

  // 5. for each file argument
  for (i = start; i < argc; i++)
  {
    // 5a. create hash table in which to track file names already printed
    std::unordered_set<std::string> printed;
    // 5b. create list to track dependencies yet to print
    std::list<std::string> toProcess;

    std::pair<std::string, std::string> pair = parseFile(argv[i]);

    std::string obj = pair.first + ".o";
    // 5c. print "foo.o:" ...
    printf("%s:", obj.c_str());
    // 5c. ... insert "foo.o" into hash table and append to list
    printed.insert(obj);
    toProcess.push_back(obj);
    // 5d. invoke
    printDependencies(&printed, &toProcess, stdout);

    printf("\n");
  }

  return 0;
}
