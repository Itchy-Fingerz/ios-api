import Foundation
import CoreLocation

/**
 This type is used to describe a single direction in a list of directions that form a route.
 */
@objc
public class WRLDNavDirection: NSObject
{
    /**
     Initialize an interior or exterior direction.
     */
    @objc public init(name name_: String,
                      icon icon_: String,
                      instruction instruction_: String,
                      thenInstruction thenInstruction_: String,
                      path path_: [CLLocationCoordinate2D],
                      indoorID indoorID_: String? = nil,
                      floorID floorID_: Int = 0,
                      isMultiFloor isMultiFloor_: Bool = false,
                      isUsingPlaceHolders isUsingPlaceHolders_: Bool = false,
                      nextIndoorMapFloorName nextIndoorMapFloorName_: String? = nil,
                      nextIndoorMapFloorID nextIndoorMapFloorID_: Int = 0)
    {
        nameValue               = name_
        icon                    = icon_
        instructionValue        = instruction_
        thenInstructionValue    = thenInstruction_
        path                    = path_
        indoorID                = indoorID_
        floorID                 = floorID_
        isMultiFloor            = isMultiFloor_
        isUsingPlaceHolders     = isUsingPlaceHolders_
        nextIndoorMapFloorName  = nextIndoorMapFloorName_
        nextIndoorMapFloorID    = nextIndoorMapFloorID_
    }
    
    /**
     The next direction indoor map floor id.
     */
    public let nextIndoorMapFloorID: Int
    
    /**
     Whether the indoor direction instruction is using placeholder value for indoor floorname
     */
    public var isUsingPlaceHolders: Bool
    
    /**
     The short floor name of this directon instruction
     */
    public var nextIndoorMapFloorName: String?
    
    /**
     The short name of this instruction.
     */
    private var nameValue: String
    @objc(name) public var name: String {
        set
        {
            if nameValue != newValue
            {
                nameValue = newValue
            }
        }
        get
        {
            if (nameValue.contains("<nextfloor>"))
            {
                let updatedText = nameValue.replacingOccurrences(of: "<nextfloor>", with: nextIndoorMapFloorName!)
                if (!isUsingPlaceHolders)
                {
                    nameValue = updatedText
                }
                return updatedText
            }
            else
            {
                return nameValue
            }
        }
    }
    
    /**
     The name of the icon. This gets prefixed to sellect the correct icon from the assets.
     */
    @objc(icon) public let icon: String
    
    /**
     The main part of the instruction for this step.
     */
    private var instructionValue: String
    @objc(instruction) public var instruction: String {
        set
        {
            if instructionValue != newValue
            {
                instructionValue = newValue
            }
        }
        get
        {
            if (instructionValue.contains("<nextfloor>"))
            {
                let updatedText = instructionValue.replacingOccurrences(of: "<nextfloor>", with: nextIndoorMapFloorName!)
                if (!isUsingPlaceHolders)
                {
                    instructionValue = updatedText
                }
                return updatedText
            }
            else
            {
                return instructionValue
            }
        }
    }
    
    /**
     The then instruction for this step.
     */
    private var thenInstructionValue: String
    @objc(thenInstruction) public var thenInstruction: String {
        set
        {
            if thenInstructionValue != newValue
            {
                thenInstructionValue = newValue
            }
        }
        get
        {
            if (thenInstructionValue.contains("<nextfloor>"))
            {
                let updatedText = thenInstructionValue.replacingOccurrences(of: "<nextfloor>", with: nextIndoorMapFloorName!)
                if (!isUsingPlaceHolders)
                {
                    thenInstructionValue = updatedText
                }
                return updatedText
            }
            else
            {
                return thenInstructionValue
            }
        }
    }
    
    /**
     The geographic path of this direction.
     */
    @objc(path) public let path: [CLLocationCoordinate2D]
    
    /**
     The name of the building that this location is within, or nil if this is not applicable.
     */
    @objc(indoorID) public let indoorID: String?
    
    /**
     The floor that this location is on or 0 if not applicable.
     */
    @objc(floorID) public let floorID: Int
    
    /**
     Whether the direction is multifloor or not
     */
    @objc(isMultiFloor) public let isMultiFloor: Bool
}
