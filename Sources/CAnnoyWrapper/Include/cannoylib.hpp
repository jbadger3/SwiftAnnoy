//
//  cannoylib.hpp
//  SwiftAnnoy
//
//  Created by Jonathan Badger on 3/15/20.
//  Copyright © 2020 Jonathan Badger. All rights reserved.
//

#ifndef cannoylib_hpp
#define cannoylib_hpp

#include <stdio.h>
#include <stdbool.h>

#ifdef __cplusplus

extern "C" {
#endif

const void * C_initializeAnnoyIndex(int f, char* dist_metric, char* dtype);
bool C_add_item(int i, void* vector, char* dist_metric, char* dtype, const void* indexPointer);
bool C_build(int num_trees, char* dist_metric, char* dtype, const void* indexPointer);
bool C_unbuild(const void* indexPointer);
bool C_save(const char* filename, bool prefault, const void* indexPointer);
void C_unload(const void* indexPointer);
bool C_load(const char* filename, char* dist_metric, char* dtype, const void* indexPointer);
void C_get_distance(int i, int j, void* result, char* dist_metric, char* dtype, const void* indexPointer);
void C_get_nns_by_item(int item, int n, int search_k, int* results, void* distances,char* dist_metric, char* dtype, const void* indexPointer);
void C_get_nns_by_vector(void* vector, int n, int search_k, int* results, void* distances, char* dist_metric, char* dtype, const void* indexPointer);
int C_get_n_items(const void* indexPointer);
int C_get_n_trees(const void* indexPointer);
void C_verbose(bool v, const void* indexPointer);
void C_get_item(int item, void* vector, char* dist_metric, char* dtype, const void* indexPointer);
void C_set_seed(int q, const void* indexPointer);
bool C_on_disk_build(const char* filename, const void* indexPointer);
void C_deleteAnnoyIndex(const void* indexPointer);

#ifdef __cplusplus
}
#endif
#endif


