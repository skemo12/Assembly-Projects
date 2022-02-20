#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_INPUT_LINE_SIZE 300

struct Dir;
struct File;

typedef struct Dir{
	char *name;
	struct Dir* parent;
	struct File* head_children_files;
	struct Dir* head_children_dirs;
	struct Dir* next;
} Dir;

typedef struct File {
	char *name;
	struct Dir* parent;
	struct File* next;
} File;

void touch (Dir* parent, char* name) {

	// Checking for parse erros
	if(parent == NULL)
	{
		return;
	}

	// Checking whether file already exists
	File *fileCheck = parent->head_children_files;
	while (fileCheck != NULL)
	{
		if (strcmp (fileCheck->name, name) == 0)
		{
			printf("File already exists\n");
			return;
		}
		
		fileCheck = fileCheck->next;
	}
	
	// Checking whether a dir with same name already exists
	Dir *directoryCheck = parent->head_children_dirs;
	while (directoryCheck != NULL)
	{
		if (strcmp (directoryCheck->name, name) == 0)
		{
			printf("File already exists\n");
			return;
		}
		
		directoryCheck = directoryCheck->next;
	}
	
	// Create new file
	File *file = (File *) calloc(1, sizeof(File));
	// Checking for failed allocations
	if (file == NULL)
	{
		printf("Alloc failed\n");
		return;
	}
	
	file->name = (char *) calloc(strlen(name) + 1, sizeof(char));
	// Checking for failed allocations
	if (file->name == NULL)
	{
		printf("Alloc failed\n");
		return;
	}

	strcpy(file->name, name);
	file->parent = parent;
	file->next = NULL;

	// Case first file in list
	File *itterator = parent->head_children_files;
	if (itterator == NULL)
	{
		parent->head_children_files = file;
		return;
	}
	
	// Case list already exists
	while (itterator->next != NULL)
	{		
		itterator = itterator->next;
	}
	itterator->next = file;
	

}

void mkdir (Dir* parent, char* name) {

	// Checking for parse erros
	if(parent == NULL)
	{
		return;
	}

	// Checking whether there is a file with same name already
	File *fileCheck = parent->head_children_files;
	while (fileCheck != NULL)
	{
		if (strcmp (fileCheck->name, name) == 0)
		{
			printf("Directory already exists\n");
			return;
		}
		
		fileCheck = fileCheck->next;
	}

	// Checking whether dir already exists
	Dir *directoryCheck = parent->head_children_dirs;
	while (directoryCheck != NULL)
	{
		if (strcmp (directoryCheck->name, name) == 0)
		{
			printf("Directory already exists\n");
			return;
		}
		directoryCheck = directoryCheck->next;
	}
	
	// Creating new dir
	Dir *dir = (Dir *) calloc(1, sizeof(Dir));
	// Checking for failed allocations
	if (dir == NULL)
	{
		printf("Alloc failed\n");
		return;
	}
	
	dir->name = (char *) calloc(strlen(name) + 1, sizeof(char));
	// Checking for failed allocations
	if (dir->name == NULL)
	{
		printf("Alloc failed\n");
		return;
	}

	strcpy(dir->name, name);
	dir->parent = parent;
	dir->head_children_files = NULL;
	dir->head_children_dirs = NULL;
	dir->next = NULL;
	
	// Case first dir in list
	Dir *itterator = parent->head_children_dirs;
	if (itterator == NULL)
	{
		parent->head_children_dirs = dir;
		return;
	}

	// Case dir list already exists
	while (itterator->next != NULL)
	{
		itterator = itterator->next;
	}
	itterator->next = dir;
}

void ls (Dir* parent) {

	// Checking for parse erros
	if(parent == NULL)
	{
		return;
	}

	// Printing all dirs
	Dir *dirs = parent->head_children_dirs;
	while (dirs != NULL)
	{
		printf("%s\n", dirs->name);
		dirs = dirs->next;
	}
	
	// Printing all files
	File *file = parent->head_children_files;
	while (file != NULL)
	{
		printf("%s\n", file->name);
		file = file->next;
	}
	
}

void rm (Dir* parent, char* name) {

	// Checking for parse erros
	if(parent == NULL)
	{
		return;
	}

	File *itterator = parent->head_children_files;
	File *prev = NULL;

	// if ok remains 0 file does not exist
	int ok = 0;

	// Searching for file
	while (itterator != NULL)
	{
		if (strcmp(itterator->name, name) == 0)
		{
			ok = 1;
			break;
		}
		prev = itterator;
		itterator = itterator->next;
	}
	
	if (ok)
	{
		// File is first in the list
		if (prev == NULL)
		{
			parent->head_children_files = parent->head_children_files->next;
			free(itterator->name);
			free(itterator);
			return;
		}
		
		prev->next = itterator->next;

		// Free memory
		free(itterator->name);
		free(itterator);
	}
	else 
	{
		// File not found
		printf("Could not find the file\n");
	}
	
}
void rmdirR (Dir *dir) {

	// A recursive utility function for rmDir that deletes a director with all
	// of the contents inside it. The functions that call this need to remove
	// the directory from the list firstly, otherwise all directories from that
	// list will be deleted.

	if (dir == NULL)
	{ 
		// Recursive base case
		return;
	}
	else
	{
		// Deleting all files from the current Directory
		File *file = dir->head_children_files;
		File *prevFile = NULL;
		while (file != NULL)
		{
			prevFile = file;
			file = file->next;
			free(prevFile->name);
			free(prevFile);
		}

		// Recursively deleting all directories	in depth
		// This makes the function into a mode similar to DFS	
		rmdirR(dir->head_children_dirs);

		// Deleting the entire list of subdirectories 
		// We need to remove the entire list of subdirectories, not just the 
		// head of the list
		Dir *itterator = dir;
		Dir *prevDir = NULL;
		while (itterator != NULL)
		{
			prevDir = itterator;
			itterator = itterator->next;
			free(prevDir->name);
			free(prevDir);
		}
		
		
	}
	
}
void rmdir (Dir* parent, char* name) {

	// Checking for parse erros
	if(parent == NULL)
	{
		return;
	}

	Dir *toBeRemoved = parent->head_children_dirs;
	Dir *prev = NULL;

	// ok remains 0 if the directory is not found
	int ok = 0;

	while (toBeRemoved != NULL)
	{
		if (strcmp(toBeRemoved->name, name) == 0)
		{
			ok = 1;
			break;
		}
		prev = toBeRemoved;
		toBeRemoved = toBeRemoved->next;
	}

	if (ok)
	{	
		// First dir in the list
		if (prev == NULL)
		{
			parent->head_children_dirs = parent->head_children_dirs->next;
			toBeRemoved->next = NULL;
			rmdirR(toBeRemoved);
			return;
		}
		
		prev->next = toBeRemoved->next;
		toBeRemoved->next = NULL;
		rmdirR(toBeRemoved);
	}
	else 
	{
		printf("Could not find the dir\n");
	}
	
}

void cd(Dir** target, char *name) {
	
	// Checking for parse errors;
	if (target == NULL || (*target) == NULL)
	{
		return;
	}
	
	// Case the call was cd ..
	if (strcmp(name, "..") == 0)
	{
		// Case we already as up as possible in hierarchy (home case)
		if ((*target)->parent == NULL)
		{
			return;
		}

		// Case cd .. is possible
		(*target) = (*target)->parent;
		return;
	}

	// Searching for directory to change into
	Dir *itterator = (*target)->head_children_dirs;
	while (itterator != NULL)
	{
		if (strcmp(itterator->name, name) == 0)
		{
			(*target) = itterator;
			return;
		}
		itterator = itterator->next;
	}
	
	// Case directory is not found
	printf("No directories found!\n");
	
}

char *pwd (Dir* target) {
	
	// Checking for parse erros
	if (target == NULL)
	{
		printf("Cannot find path for NULL directory\n");
		return NULL;
	}
	
	int maxSize = MAX_INPUT_LINE_SIZE;
	int currSize = 0;
	char *path = (char *) calloc(maxSize, sizeof(char));
	char *aux = (char *) calloc(maxSize, sizeof(char));

	while (target->parent != NULL)
	{
		strcpy(aux, "/");
		strcpy(aux + 1, target->name);
		
		strcat(aux, path);
		strcpy(path, aux);
		currSize = currSize + strlen(aux);

		// Checking for longer than string size path
		if (maxSize - currSize <= MAX_INPUT_LINE_SIZE / 2)
		{
			maxSize = 2 * maxSize;
			path = (char *) realloc(path, maxSize * sizeof(char));
			aux = (char *) realloc(aux, maxSize * sizeof(char));
		}
		

		target = target->parent;
	}
	
	// Adding /home to path
	strcpy(aux, "/home");
	strcat(aux, path);
	strcpy(path, aux);
	free(aux);
	return path;
}

void stop (Dir* target) {
	
	// Destroy the whole enviroment, frees all used memory
	
	Dir *dir = target->head_children_dirs;
	Dir *prevDir = dir;

	// Destroy all directors recursively from target/home
	while (dir != NULL)
	{
		prevDir = dir;
		dir = dir->next;
		prevDir->next = NULL;
		rmdirR(prevDir);
				
	}

	// Destroy all files from main directory (files from subdirectories
	// already destroyed with recursive remove used above)
	File *file = target->head_children_files;
	File *prevFile = NULL;
	while (file != NULL)
	{
		prevFile = file;
		file = file->next;
		rm(target, prevFile->name);
	
	}

	// Free main directory (home)
	free(target->name);
	free(target);
}

void tree (Dir* target, int level) {

	// Base case
	if (target == NULL)
	{
		return;
	}
	else
	{
		// Printing the directory name from the list
		// We dont print target->name because we dont to print the name of the
		// directory that the function was called into
		Dir *itterator = target->head_children_dirs;
		while (itterator != NULL)
		{
			for (int i = 0; i < level; i++)
			{
				printf("    ");
			}
			printf("%s\n", itterator->name);

			// Printing directory contents recursively
			tree(itterator, level + 1);
			
			// After printing the directories in a similar mode to DFS, we print 
			// the files in the list
			File *file = target->head_children_files;
			while (file != NULL)
			{
				for (int i = 0; i < level; i++)
				{
					printf("    ");
				}
				printf("%s\n", file->name);
				file = file->next;
			}
			itterator = itterator->next;	
		} 
		
	}
	
}

void mv(Dir* parent, char *oldname, char *newname) {

	int isFile = 0;
	int isDir = 0;

	// We check whether oldname is a file
	File *fileCheck = parent->head_children_files;
	File *prevFile = NULL;
	while (fileCheck != NULL)
	{
		
		if (strcmp(fileCheck->name, oldname) == 0)
		{
			isFile = 1;
			break;
		}
		prevFile = fileCheck;
		fileCheck = fileCheck->next;
	}
	
	// We check whether oldname is a dir
	Dir *dirCheck = parent->head_children_dirs;
	Dir *prevDir = NULL;
	while (dirCheck != NULL)
	{
		
		if (strcmp(dirCheck->name, oldname) == 0)
		{
			isDir = 1;
			break;
		}
		prevDir = dirCheck;
		dirCheck = dirCheck->next;
	}
		
	// Case it is neither a file or a dir (so it does not exist)
	if (!isFile && !isDir)
	{
		printf("File/Director not found\n");
		return;
	}
	
	// We check if the new file/dir can be created
	fileCheck = parent->head_children_files;
	while (fileCheck != NULL)
	{
		if (strcmp(fileCheck->name, newname) == 0)
		{
			printf("File/Director already exists\n");
			return;
		}
		
		fileCheck = fileCheck->next;
	}
	
	dirCheck = parent->head_children_dirs;
	while (dirCheck != NULL)
	{
		if (strcmp(dirCheck->name, newname) == 0)
		{
			printf("File/Director already exists\n");
			return;
		}

		dirCheck = dirCheck->next;
	}
	
	// If it's a file, we just remove the old one and create a new one
	if (isFile)
	{
		rm(parent, oldname);
		touch(parent, newname);
		return;
	}

	// If it's a dir, we move the whole dir with all it's subdirs and subfiles
	// at the end of the list and change it's name
	if (isDir)
	{
		Dir *last = parent->head_children_dirs;
		while (last->next != NULL)
		{
			last = last->next;
		}
		if (prevDir == NULL)
		{
			// The dir is the first dir of the list
			dirCheck = parent->head_children_dirs;
			last->next = dirCheck;
			parent->head_children_dirs = parent->head_children_dirs->next;
			dirCheck->next = NULL;
			strcpy(dirCheck->name, newname);
			return;
		}
		
		dirCheck = prevDir->next;
		strcpy(dirCheck->name, newname);

		// If dir is last we have nothing else to do.
		if (dirCheck == last)
		{
			return;
		}
		
		prevDir->next = dirCheck->next;
		last->next = dirCheck;
		dirCheck->next = NULL;
		return;

	}
	
}

int main () {

	// We create the enviroment to work into, the home dir
	Dir *home = (Dir *) calloc(1, sizeof(Dir));
	home->name = (char *) calloc(5, sizeof(char));
	strcpy(home->name, "home");
	home->parent = NULL;
	home->next = NULL;
	home->head_children_dirs = NULL;
	home->head_children_files = NULL;

	// currentDirectory keeps track of the working dir
	Dir *currentDirectory = home;

	// The max input a line can have
	char *input = (char *) calloc(MAX_INPUT_LINE_SIZE, sizeof(char));
	do
	{
		/*
		Summary:
			Reads from stdin a string and breaks it down into command and in
			case it needs into a name.
		*/
		
		// We check the first word
		scanf("%s", input);

		// Break it into cases
		if (strcmp(input, "touch") == 0 )
		{
			scanf("%s", input);
			touch(currentDirectory, input);
		}
		else if (strcmp(input, "mkdir") == 0 )
		{
			scanf("%s", input);
			mkdir(currentDirectory, input);
		}
		else if (strcmp(input, "ls") == 0 )
		{
			ls(currentDirectory);
		}
		else if (strcmp(input, "cd") == 0)
		{
			scanf("%s", input);
			cd(&currentDirectory, input);
		} 
		else if (strcmp(input, "rm") == 0)
		{
			scanf("%s", input);
			rm(currentDirectory, input);
		}
		else if (strcmp(input, "rmdir") == 0)
		{
			scanf("%s", input);
			rmdir(currentDirectory, input);
		}
		else if (strcmp(input, "tree") == 00)
		{
			// We call the functions like this because we do not want to print 
			// the main directory that we call the function into, only it's
			// content
			tree(currentDirectory, 0);			
		}
		else if (strcmp(input, "pwd") == 0)
		{
			char *path = pwd(currentDirectory);
			printf("%s\n", path);
			free(path);
		}
		else if (strcmp(input, "mv") == 0)
		{
			// First input is oldName, second is newName
			scanf("%s", input);
			char *input2 = (char *) calloc(MAX_INPUT_LINE_SIZE, sizeof(char));
			scanf("%s", input2);
			mv(currentDirectory, input, input2);
			free(input2);
		}
		else if (strcmp(input, "stop") == 0 )
		{
			stop(home);
			free(input);
			break;
		}
		
	} while (1);

	
	return 0;
}
