local anchorPointAdjustments = {}

function anchorPointAdjustments:AddToUDim(UDimValue: UDim, ToAddScale: number?, ToAddOffset: number?): UDim
	return UDim.new(UDimValue.Scale + (ToAddScale or 0), UDimValue.Offset + (ToAddOffset or 0))
end

function anchorPointAdjustments:AddUDims(UDimValue: UDim, UDimToAdd: UDim): UDim
	return UDim.new(UDimValue.Scale + UDimToAdd.Scale, UDimValue.Offset + UDimToAdd.Offset)
end

function anchorPointAdjustments:MultiplyUDim(
	UDimValue: UDim,
	Scalar: number?,
	ToAddValue: number?,
	ToAddScalar: number?
): UDim
	return UDim.new(
		UDimValue.Scale + (ToAddValue or 0) * (Scalar or 1) + (ToAddScalar or 0),
		UDimValue.Offset + (ToAddValue or 0) * (Scalar or 1) + (ToAddScalar or 0)
	)
end

function anchorPointAdjustments:MultiplyUDims(
	UDimValue: UDim,
	UDimScalar: UDim,
	ToAddValue: number?,
	ToAddScalar: number?
): UDim
	local scaledUDim: UDim = UDim.new(UDimValue.Scale * UDimScalar.Scale, UDimValue.Offset * UDimScalar.Offset)
	return self:AddToUDim(scaledUDim, (ToAddValue or 0) + (ToAddScalar or 0))
end

function anchorPointAdjustments:CalculateOffset(CurrentSize: UDim2, AnchorPoint: Vector2): UDim2
	return UDim2.new(
		UDim.new(CurrentSize.X.Scale * AnchorPoint.X, CurrentSize.X.Offset * AnchorPoint.X),
		UDim.new(CurrentSize.Y.Scale * AnchorPoint.Y, CurrentSize.Y.Offset * AnchorPoint.Y)
	)
end

function anchorPointAdjustments:GetAdjustedPositionScale(
	Position: UDim2,
	Size: UDim2,
	OldAnchorPoint: Vector2,
	NewAnchorPoint: Vector2
): UDim2
	local oldOffset: UDim2 = self:CalculateOffset(Size, OldAnchorPoint)
	local newOffset: UDim2 = self:CalculateOffset(Size, NewAnchorPoint)

	local result: UDim2 = Position - oldOffset + newOffset
	return UDim2.fromScale(result.X.Scale, result.Y.Scale)
end

function anchorPointAdjustments:GetAdjustedPositionOffset(
	Position: UDim2,
	Size: UDim2,
	OldAnchorPoint: Vector2,
	NewAnchorPoint: Vector2
): UDim2
	local oldOffset: UDim2 = self:CalculateOffset(Size, OldAnchorPoint)
	local newOffset: UDim2 = self:CalculateOffset(Size, NewAnchorPoint)

	local result: UDim2 = Position - oldOffset + newOffset
	return UDim2.fromOffset(result.X.Offset, result.Y.Offset)
end

function anchorPointAdjustments:AdjustPositionScale(UIObject: GuiObject, NewAnchorPoint: Vector2): ()
	UIObject.AnchorPoint = NewAnchorPoint
	UIObject.Position =
		self:GetAdjustedPositionScale(UIObject.Position, UIObject.Size, UIObject.AnchorPoint, NewAnchorPoint)
end

function anchorPointAdjustments:AdjustPositionOffset(UIObject: GuiObject, NewAnchorPoint: Vector2): ()
	UIObject.AnchorPoint = NewAnchorPoint
	UIObject.Position =
		self:GetAdjustedPositionOffset(UIObject.Position, UIObject.Size, UIObject.AnchorPoint, NewAnchorPoint)
end

return anchorPointAdjustments
