//
//  cannoylib.cpp
//  SwiftAnnoy
//
//  Created by Jonathan Badger on 5/2/20.
//  Copyright © 2020 Jonathan Badger. All rights reserved.
//
#include "cannoylib.hpp"
#include "annoylib.h"
#include "kissrandom.h"
#include <stdio.h>


const void * C_initializeAnnoyIndex(int f, char* dist_metric, char* dtype) {
    if (strcmp(dtype, "Float") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = new AnnoyIndex<int, float, Euclidean, Kiss32Random>(f);
            return (void *)index;
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, float, Manhattan, Kiss32Random> *index = new AnnoyIndex<int, float, Manhattan, Kiss32Random>(f);
            return (void *)index;
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, float, DotProduct, Kiss32Random> *index = new AnnoyIndex<int, float, DotProduct, Kiss32Random>(f);
            return (void *)index;
        }
    } else if (strcmp(dtype, "Double") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, double, Euclidean, Kiss32Random> *index = new AnnoyIndex<int, double, Euclidean, Kiss32Random>(f);
            return (void *)index;
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, double, Manhattan, Kiss32Random> *index = new AnnoyIndex<int, double, Manhattan, Kiss32Random>(f);
            return (void *)index;
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, double, DotProduct, Kiss32Random> *index = new AnnoyIndex<int, double, DotProduct, Kiss32Random>(f);
            return (void *)index;
        }
    }
    int fail = -1;
    int* failPtr = &fail;
    return (void *)failPtr;
}



bool C_add_item(int i, void* vector, char* dist_metric, char* dtype, const void* indexPointer) {
    if (strcmp(dtype, "Float") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
            const float *vec = (const float *)vector;
            return index->add_item(i, vec);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, float, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, float, Manhattan, Kiss32Random> *)indexPointer;
            const float *vec = (const float *)vector;
            return index->add_item(i, vec);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, float, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, float, DotProduct, Kiss32Random> *)indexPointer;
            const float *vec = (const float *)vector;
            return index->add_item(i, vec);
        }
    } else if (strcmp(dtype, "Double") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, double, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, double, Euclidean, Kiss32Random> *)indexPointer;
            const double *vec = (const double *)vector;
            return index->add_item(i, vec);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, double, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, double, Manhattan, Kiss32Random> *)indexPointer;
            const double *vec = (const double *)vector;
            return index->add_item(i, vec);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, double, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, double, DotProduct, Kiss32Random> *)indexPointer;
            const double *vec = (const double *)vector;
            return index->add_item(i, vec);
        }
    }
    return false;
}

bool C_build(int num_trees, char * dist_metric, char* dtype, const void* indexPointer) {
    AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
    return index->build(num_trees);
}

bool C_unbuild(const void* indexPointer) {
    AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
    return index->unbuild();
}

bool C_save(const char* filename, const void* indexPointer) {
    AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
    return index->save(filename);
}

void C_unload(const void* indexPointer) {
    AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
    index->unload();
}

bool C_load(const char* filename, char* dist_metric, char* dtype, const void* indexPointer) {
    if (strcmp(dtype, "Float") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
            return index->load(filename);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, float, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, float, Manhattan, Kiss32Random> *)indexPointer;
            return index->load(filename);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, float, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, float, DotProduct, Kiss32Random> *)indexPointer;
            return index->load(filename);
        }
    } else if (strcmp(dtype, "Double") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, double, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, double, Euclidean, Kiss32Random> *)indexPointer;
            return index->load(filename);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, double, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, double, Manhattan, Kiss32Random> *)indexPointer;
            return index->load(filename);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, double, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, double, DotProduct, Kiss32Random> *)indexPointer;
            return index->load(filename);
        }
    }
    return false;
}


void C_get_distance(int i, int j, void* result, char* dist_metric, char* dtype, const void* indexPointer){
    if (strcmp(dtype, "Float") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
            float dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, float, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, float, Manhattan, Kiss32Random> *)indexPointer;
            float dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, float, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, float, DotProduct, Kiss32Random> *)indexPointer;
            float dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
    } else if (strcmp(dtype, "Double") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, double, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, double, Euclidean, Kiss32Random> *)indexPointer;
            double dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, double, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, double, Manhattan, Kiss32Random> *)indexPointer;
            double dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, double, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, double, DotProduct, Kiss32Random> *)indexPointer;
            double dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
    }
}

void C_get_nns_by_item(int item, int n, int search_k, int* results, void* distances,char * dist_metric, char* dtype, const void* indexPointer) {
    if (strcmp(dtype, "Float") == 0) {
        std::vector<int> res;
        std::vector<float> dis;
        float* distancesBuffer = (float *)distances;
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, float, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, float, Manhattan, Kiss32Random> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);

        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, float, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, float, DotProduct, Kiss32Random> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        for (int i = 0; i < res.size(); i++){
            results[i] = res[i];
            distancesBuffer[i] = dis[i];
        }
    } else if (strcmp(dtype, "Double") == 0) {
        std::vector<int> res;
        std::vector<double> dis;
        double* distancesBuffer = (double *)distances;
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, double, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, double, Euclidean, Kiss32Random> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, double, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, double, Manhattan, Kiss32Random> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, double, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, double, DotProduct, Kiss32Random> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        for (int i = 0; i < res.size(); i++){
            results[i] = res[i];
            distancesBuffer[i] = dis[i];
        }
    }
}

void C_get_nns_by_vector(void* vector, int n, int search_k, int* results, void* distances, char * dist_metric, char* dtype, const void* indexPointer) {
    if (strcmp(dtype, "Float") == 0) {
        std::vector<int> res;
        std::vector<float> dis;
        const float *vec = (float *)vector;
        float* distancesBuffer = (float *)distances;
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, float, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, float, Manhattan, Kiss32Random> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);

        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, float, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, float, DotProduct, Kiss32Random> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        for (int i = 0; i < res.size(); i++){
            results[i] = res[i];
            distancesBuffer[i] = dis[i];
        }
    } else if (strcmp(dtype, "Double") == 0) {
        std::vector<int> res;
        std::vector<double> dis;
        const double *vec = (double *)vector;
        double* distancesBuffer = (double *)distances;
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, double, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, double, Euclidean, Kiss32Random> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, double, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, double, Manhattan, Kiss32Random> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, double, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, double, DotProduct, Kiss32Random> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        for (int i = 0; i < res.size(); i++){
            results[i] = res[i];
            distancesBuffer[i] = dis[i];
        }
    }
}


int C_get_n_items(const void* indexPointer) {
    //The actual underlying type does not matter for this func
    AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
    int n_items = index->get_n_items();
    return n_items;
}

int C_get_n_trees(const void* indexPointer) {
    //The actual underlying type does not matter for this func
    AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
    int n_trees = index->get_n_trees();
    return n_trees;
}

void C_verbose(bool v, const void* indexPointer) {
    //The actual underlying type does not matter for this func
    AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
    index->verbose(v);
}

void C_get_item(int item, void* vector, char* dist_metric, char* dtype, const void* indexPointer){
    if (strcmp(dtype, "Float") == 0) {
        float* vec = (float *)vector;
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
            index->get_item(item, vec);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, float, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, float, Manhattan, Kiss32Random> *)indexPointer;
            index->get_item(item, vec);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, float, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, float, DotProduct, Kiss32Random> *)indexPointer;
            index->get_item(item, vec);
        }
    } else if (strcmp(dtype, "Double") == 0) {
        double* vec = (double *)vector;
        if (strcmp(dist_metric, "euclidean") == 0) {
            AnnoyIndex<int, double, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, double, Euclidean, Kiss32Random> *)indexPointer;
            index->get_item(item, vec);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            AnnoyIndex<int, double, Manhattan, Kiss32Random> *index = (AnnoyIndex<int, double, Manhattan, Kiss32Random> *)indexPointer;
            index->get_item(item, vec);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            AnnoyIndex<int, double, DotProduct, Kiss32Random> *index = (AnnoyIndex<int, double, DotProduct, Kiss32Random> *)indexPointer;
            index->get_item(item, vec);
        }
    }
}

void C_set_seed(int q, const void* indexPointer) {
    AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
    index->set_seed(q);
}

bool C_on_disk_build(const char* filename, const void* indexPointer) {
    AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
    return index->on_disk_build(filename);
}

void C_deleteAnnoyIndex(const void* indexPointer) {
    AnnoyIndex<int, float, Euclidean, Kiss32Random> *index = (AnnoyIndex<int, float, Euclidean, Kiss32Random> *)indexPointer;
    index->unbuild();
    delete index;
}


