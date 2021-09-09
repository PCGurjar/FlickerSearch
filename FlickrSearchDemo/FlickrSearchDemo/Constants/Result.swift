//
//  Result.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 19/02/21.
//

import UIKit

enum Result <T>{
    case Success(T)
    case Failure(String)
    case Error(String)
}
